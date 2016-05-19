from threading import Thread
from time import time, sleep
from subprocess import call
from random import gauss
import sched
from yaml import load


from message_store import DataStore
from aDTN import aDTN

DEVICE_NAME = 'maxwell'
IFACE = 'wlp3s0'
EXPERIMENT_DURATION = 5 * 24 * 60 * 60 # 5 days in seconds

# According to http://www.internetlivestats.com/twitter-statistics/ there was an avg of 350,000 tweets/minute in 2015.
# According to http://www.statista.com/statistics/282087/number-of-monthly-active-twitter-users/ Twitter had
# 350,000,000 users in 2015. That makes 0.07 tweets per hour per user, on average - i.e. 1 tweet every 14.28 hours.
CREATION_RATE = 14.28
SENDING_FREQS = [5, 10, 30, 60]
BATCH_SIZE = [1,10, 20]


class MessageGenerator:
    """
    Generates messages of the form dn_ct where dn is the name of the device creating the message and ct is a counter
    serving as a unique identifier for the messages created by the device.
    The generation is scheduled to happen on average every creation_rate seconds, following a gaussian distribution.
    """
    def __init__(self, creation_rate, device_name):
        self.creation_rate = creation_rate
        self.device_name = device_name
        self.next_message = 0
        self.ms = DataStore()
        self.scheduler = sched.scheduler(time, sleep)
        self.run()

    def writing_interval(self):
        return abs(gauss(self.creation_rate, self.creation_rate / 4))

    def write_message(self):
        self.scheduler.enter(self.writing_interval(), 2, self.write_message)
        self.ms.add_object(self.device_name + '_' + str(self.next_message))
        self.next_message += 1

    def run(self):
        self.scheduler.enter(self.writing_interval(), 2, self.write_message)


class LocationManager:
    """
    Changes the ESSID of this device according to a schedule in order to simulate a new set of neighbors.
    """
    def __init__(self, id):
        try:
            config = open("scheduling/{}.yaml".format(id))
        except OSError:
            print("Invalid schedule.")
            raise
        self.schedule = load(config.read())
        self.scheduler = sched.scheduler(time, sleep)
        self.run()

    def schedule_joining(self, essid):
        self.scheduler.enter(24 * 60 * 60, 2, self.schedule.joining, (essid,))  # repeat every 24h
        call("iw {} ibss join {} 2432".format(IFACE, essid))

    def schedule_leaving(self):
        self.scheduler.enter(24 * 60 * 60, 2, self.schedule.leaving)  # repeat every 24h
        call("iw {} ibss leave".format(IFACE))

    def run(self):
        for network in self.schedule:
            location = network['location']
            begin = network['begin']
            end = network['end']
            beginning_time = 0
            ending_time = 0
            self.scheduler.enterabs(beginning_time, 2, self.schedule_joining, (location,))
            self.scheduler.enterabs(ending_time, 2 , self.schedule_leaving)



def run():
    for bs in BATCH_SIZE:
        for sf in SENDING_FREQS:
            # Inform about current config.
            fn = "_".join([str(i) for i in [bs, sf, CREATION_RATE]])
            print("Now running: {}".format(fn))

            # Start aDTN
            t_adtn = Thread(target=aDTN, args =(bs, sf, CREATION_RATE, DEVICE_NAME, IFACE,), kwargs={"data_store": fn})

            # Start message generation
            t_generate_messages = Thread(target=MessageGenerator, args=(CREATION_RATE, DEVICE_NAME))

            sleep(EXPERIMENT_DURATION)
            t_adtn._stop()
            t_generate_messages._stop()





LocationManager(1)
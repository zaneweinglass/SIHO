def sim_and_save(input_seed, num_days, output_name):

    from collections import namedtuple
    import random, heapq, csv, math
    import numpy as np
    import pandas as pd


    random.seed(input_seed)

    Schedule = namedtuple("Schedule", ["time", "priority", "event_id", "event_name", "scheduled_by"])

    def schedule(event_name, time, state_space, event_queue, scheduler_id):
        heapq.heappush(event_queue, Schedule(time, state_space["event_priorities"][event_name], state_space["next_event_id"], event_name, scheduler_id))
        state_space["next_event_id"] = state_space["next_event_id"] + 1

    def cancel(event_name, event_queue):
        #cancelled_events = [e for e in event_queue if e.event_name == event_name]
        event_queue[:] = [e for e in event_queue if e.event_name != event_name]
        #copies everything event that is not the event you want to cancel
        #return cancelled_events

    def simulate(events, event_priorities, init_name = "init", verbose = True):
        state_space = {"time": 0, "next_event_id": 0, "event_priorities": event_priorities}
        event_queue = [] # we use heapq to turn this into a priority queue
        schedule(init_name, 0, state_space, event_queue, -1)

        while len(event_queue) > 0:
            cur_event = heapq.heappop(event_queue)
            #if verbose:
                #print("Event %i (%s) at time %.2f (scheduled by %i)" % (cur_event.event_id, cur_event.event_name, cur_event.time, cur_event.scheduled_by))
            state_space["time"] = cur_event.time
            events[cur_event.event_name](state_space, event_queue, cur_event.event_id)

        return (state_space, event_queue)

    def init(state_space, event_queue, event_id):
        state_space["NDPD1"] = [ ]
        state_space["NDPD1"].append(0)
        state_space["NHAPD1"] = [ ]
        state_space["NHAPD1"].append(0)
        state_space["NIPD1"] = [ ]
        state_space["NIPD1"].append(0)
        state_space["NRPD1"] = [ ]
        state_space["NRPD1"].append(0)
        state_space["NDPD2"] = [ ]
        state_space["NDPD2"].append(0)
        state_space["NHAPD2"] = [ ]
        state_space["NHAPD2"].append(0)
        state_space["NIPD2"] = [ ]
        state_space["NIPD2"].append(0)
        state_space["NRPD2"] = [ ]
        state_space["NRPD2"].append(0)
        state_space["HOCC1PD"] = [ ]
        state_space["HOCC1PD"].append(0)
        state_space["HOCC2PD"] = [ ]
        state_space["HOCC2PD"].append(0)
        state_space["TI1"] = 0
        state_space["TI2"] = 0
        state_space["TD1"] = 0
        state_space["TD2"] = 0
        state_space["THA1"] = 0
        state_space["THA2"] = 0
        state_space["TR1"] = 0
        state_space["TR2"] = 0
        state_space["HOCC1"] = 0
        state_space["HOCC2"] = 0
        state_space["NPPD1"] = [ ]
        state_space["NPPD1"].append(0)
        state_space["TP1"] = 0
        state_space["NPPD2"] = [ ]
        state_space["NPPD2"].append(0)
        state_space["TP2"] = 0


        schedule("LOG", state_space["time"] + 1, state_space, event_queue, event_id)
        schedule("INF1", state_space["time"] + np.random.exponential(1/2473.32), state_space, event_queue, event_id)
        schedule("INF2", state_space["time"] + np.random.exponential(1/1428.18), state_space, event_queue, event_id)
        schedule("write_csv", 100000, state_space, event_queue, event_id)
        schedule("close", num_days, state_space, event_queue, event_id)

    def LOG(state_space, event_queue, event_id):
        state_space["NIPD1"].append(state_space["TI1"] - sum(state_space["NIPD1"]))
        state_space["NIPD2"].append(state_space["TI2"] - sum(state_space["NIPD2"]))
        state_space["NDPD1"].append(state_space["TD1"] - sum(state_space["NDPD1"]))
        state_space["NDPD2"].append(state_space["TD2"] - sum(state_space["NDPD2"]))
        state_space["NHAPD1"].append(state_space["THA1"] - sum(state_space["NHAPD1"]))
        state_space["NHAPD2"].append(state_space["THA2"] - sum(state_space["NHAPD2"]))
        state_space["NRPD1"].append(state_space["TR1"] - sum(state_space["NRPD1"]))
        state_space["NRPD2"].append(state_space["TR2"] - sum(state_space["NRPD2"]))
        state_space["HOCC1PD"].append(state_space["HOCC1"])
        state_space["HOCC2PD"].append(state_space["HOCC2"])
        state_space["NPPD1"].append(state_space["TP1"] - sum(state_space["NPPD1"]))
        state_space["NPPD2"].append(state_space["TP2"] - sum(state_space["NPPD2"]))
        
        schedule("LOG", state_space["time"] + 1, state_space, event_queue, event_id)

    def INF1(state_space, event_queue, event_id):
        state_space["TI1"] = state_space["TI1"] + 1
        U = np.random.uniform(low = 0.0, high = 1.0)
        if U <= 0.2729872:
            schedule("HOSP1", state_space["time"], state_space, event_queue, event_id)
        else:
            schedule("RNH1", state_space["time"], state_space, event_queue, event_id)
        
        schedule("INF1", state_space["time"] + np.random.exponential(1/2473.32), state_space, event_queue, event_id)

    def INF2(state_space, event_queue, event_id):
        state_space["TI2"] = state_space["TI2"] + 1
        U = np.random.uniform(low = 0.0, high = 1.0)
        if U <= 0.3374091:
            schedule("HOSP2", state_space["time"], state_space, event_queue, event_id)
        else:
            schedule("RNH2", state_space["time"], state_space, event_queue, event_id)
        schedule("INF2", state_space["time"] + np.random.exponential(1/1428.18), state_space, event_queue, event_id)

    def HOSP1(state_space, event_queue, event_id):
        state_space["THA1"] = state_space["THA1"] + 1
        state_space["HOCC1"] = state_space["HOCC1"] + 1
        U = np.random.uniform(low = 0.0, high = 1.0)
        if U <= 0.248187:
            schedule("DIE1", state_space["time"] + np.random.exponential(7), state_space, event_queue, event_id)
        else:
            schedule("RNH1", state_space["time"] + np.random.exponential(7), state_space, event_queue, event_id)

    def HOSP2(state_space, event_queue, event_id):
        state_space["THA2"] = state_space["THA2"] + 1
        state_space["HOCC2"] = state_space["HOCC2"] + 1
        U = np.random.uniform(low = 0.0, high = 1.0)
        if U <= 0.2939376:
            schedule("DIE2", state_space["time"] + np.random.exponential(7), state_space, event_queue, event_id)
        else:
            schedule("RNH2", state_space["time"] + np.random.exponential(7), state_space, event_queue, event_id)

    def DIE1(state_space, event_queue, event_id):
        state_space["TD1"] = state_space["TD1"] + 1
        state_space["HOCC1"] = state_space["HOCC1"] - 1
        state_space["TP1"] = state_space["TP1"] + 1

    def DIE2(state_space, event_queue, event_id):
        state_space["TD2"] = state_space["TD2"] + 1
        state_space["HOCC2"] = state_space["HOCC2"] - 1
        state_space["TP2"] = state_space["TP2"] + 1

    def RNH1(state_space, event_queue, event_id):
        state_space["TR1"] = state_space["TR1"] + 1

    def RNH2(state_space, event_queue, event_id):
        state_space["TR2"] = state_space["TR2"] + 1

    def RH1(state_space, event_queue, event_id):
        state_space["TR1"] = state_space["TR1"] + 1
        state_space["HOCC1"] = state_space["HOCC1"] - 1
        state_space["TP1"] = state_space["TP1"] + 1

    def RH2(state_space, event_queue, event_id):
        state_space["TR2"] = state_space["TR2"] + 1
        state_space["HOCC2"] = state_space["HOCC2"] - 1
        state_space["TP2"] = state_space["TP2"] + 1

    def write_csv(state_space, event_queue, event_id):

        a = np.array(state_space["NDPD1"])
        b = np.array(state_space["NHAPD1"])
        c = np.array(state_space["NIPD1"])
        d = np.array(state_space["NRPD1"])
        e = np.array(state_space["NDPD2"])
        f = np.array(state_space["NHAPD2"])
        g = np.array(state_space["NIPD2"])
        h = np.array(state_space["NRPD2"])
        i = np.array(state_space["HOCC1PD"])
        j = np.array(state_space["HOCC2PD"])
        k = np.array(state_space["NPPD1"])
        l = np.array(state_space["NPPD2"])

        df = pd.DataFrame({"NDPD1" : a, "NHAPD1" : b, "NIPD1" : c,
                        "NRPD1" : d, "NDPD2" : e, "NHAPD2" : f, 
                        "NIPD2" : g, "NRPD2" : h, "HOCC1PD" : i, 
                        "HOCC2PD" : j, "NPPD1" : k, "NPPD2": l})
        
        df.to_csv("~/Desktop/GlassRoot/UniversityProjects/SIHO/generated_data/" + output_name + ".csv")

    def close(state_space, event_queue, event_id):
        cancel("INF1", event_queue)
        cancel("INF2", event_queue)
        cancel("LOG", event_queue)

    events = {
        "init": init, "INF1": INF1, "INF2": INF2, "close": close, "LOG": LOG, 
        "HOSP1": HOSP1, "HOSP2": HOSP2, "RNH1": RNH1, "RNH2": RNH2, "DIE1": DIE1,
        "DIE2": DIE2, "write_csv": write_csv, "RH1": RH1, "RH2": RH2
    }

    event_priorities = {
        "init": 0, "INF1": -11, "INF2": -10, "close": 1, "LOG": -1, 
        "HOSP1": -7, "HOSP2": -6, "RNH1": -5, "RNH2": -4, "DIE1": -9,
        "DIE2": -8, "write_csv": 2, "RH1": -3, "RH2": -2 
    }

    final_state_space, final_event_queue = simulate(events, event_priorities)
    # print(final_state_space)
    print("Simulation " + output_name + " Completed.")
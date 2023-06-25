from collections import namedtuple
import random, heapq, csv, math
import numpy as np
import pandas as pd

# import simulation function
from sim import sim_and_save

# run simulation and save results

## short runs (n = 3650)
sim_and_save(input_seed = 1, num_days = 3650, output_name = "sr_1")
sim_and_save(input_seed = 3, num_days = 3650, output_name = "sr_2")
sim_and_save(input_seed = 5, num_days = 3650, output_name = "sr_3")
sim_and_save(input_seed = 7, num_days = 3650, output_name = "sr_4")
sim_and_save(input_seed = 9, num_days = 3650, output_name = "sr_5")
sim_and_save(input_seed = 11, num_days = 3650, output_name = "sr_6")
sim_and_save(input_seed = 13, num_days = 3650, output_name = "sr_7")
sim_and_save(input_seed = 15, num_days = 3650, output_name = "sr_8")
sim_and_save(input_seed = 17, num_days = 3650, output_name = "sr_9")
sim_and_save(input_seed = 19, num_days = 3650, output_name = "sr_10")

## long run (n = 36500)
sim_and_save(input_seed = 79, num_days = 36500, output_name = "lr")

print("All Simulations Completed.")
# Import some constants
import json
from datetime import datetime, timedelta

import csv
import pandas as pd

# Get data files
watch_round1_session1 = pd.read_csv('watch_round1_session1.csv')
watch_round1_session2 = pd.read_csv('watch_round1_session2.csv')
watch_round1_session3 = pd.read_csv('watch_round1_session3.csv')
watch_round2_session1 = pd.read_csv('watch_round2_session1.csv')
watch_round2_session2 = pd.read_csv('watch_round2_session2.csv')
watch_round2_session3 = pd.read_csv('watch_round2_session3.csv')

round1_files = [watch_round1_session1, watch_round1_session2, watch_round1_session3]
round2_files = [watch_round2_session1, watch_round2_session2, watch_round2_session3]

# Load session activity log
with open("sessions_log.json", "r") as f:
    session_log = json.loads(f.read())

### Constants and Functions ###
# Two rounds of data collection
rounds = ['round1', 'round2']
# For each data collection round there was 1 user participating
users_per_round = 1
# For each data collection round there were 3 separate sessions
sessons_per_round = 3

# Timestamp format to follow
time_format = '%Y-%m-%d %H:%M:%S.%f'

# Columns to use from the csv data
session_sensor_data_columns = [
    "loggingTime(txt)",
    "motionRotationRateX(rad/s)",
    "motionRotationRateY(rad/s)",
    "motionRotationRateZ(rad/s)",
    "motionUserAccelerationX(G)",
    "motionUserAccelerationY(G)",
    "motionUserAccelerationZ(G)"
]

# Helper functions
def convert_timestamp(x):
    return datetime.fromtimestamp(x).strftime(time_format)

def chunks(l, n):
    """Yield successive n-sized chunks from l."""
    for i in range(0, len(l), n):
        yield l[i:i + n]

def make_delta(time):
    h, m, seconds = time.split(':')
    s, milli = seconds.split('.')
    milli = milli + str(0)
    return timedelta(hours=int(h), minutes=int(m), seconds=int(s), milliseconds=int(milli))

################################

# Load Activity Data

# Iterate through all user session logs
# Map to the proper activity label
# Concatenate into a single activity dataframe

session_id = 0 # Keep track of session id: unique to each user file
activity_data = pd.DataFrame()

# For each round of data collection
for rnd in rounds:
    print(f'Parsing {rnd} activity data', flush=True)
    # Grab the files for this round
    if(rnd == 'round1'):
        rnd_files = round1_files
    else:
        rnd_files = round2_files
    # Group files for the round by session
    rnd_session_files = list(chunks(rnd_files, users_per_round))
    # Should have the right number of sessions, each file within a session is a unique user
    assert len(rnd_session_files) == sessons_per_round
    # For each session (3) within the round
    for session in range(sessons_per_round):
        print(f'Parsing session {session + 1} data files', flush=True)
        # Grab the user activity log files for this session
        session_files = rnd_session_files[session]
        # Grab the activity labels for this session
        session_log_data = session_log[rnd]['session' + str(1+session)]
        # For each user
        for user_file in session_files:
            # Load user file for this session - fix timestamp and add session id
            user_log_df = user_file[session_sensor_data_columns]
            user_log_df["loggingTime"] = user_log_df["loggingTime(txt)"].apply(lambda x: pd.to_datetime(x).replace(tzinfo=None))
            user_log_df.drop("loggingTime(txt)", axis=1, inplace=True)
            user_log_df["sessionId"] = session_id
            session_id += 1
            # Convert timestamp and make sure it's ordered appropriately
            user_log_df.sort_values(by="loggingTime", ascending=True)
            first_val = user_log_df["loggingTime"][0]
            # Get the logs that contain the activity labels for this session
            user_session_activity_df = pd.DataFrame({
                'activity': pd.Series([s[0] for s in session_log_data], dtype=str),
                'loggingTime': pd.Series([first_val + make_delta(s[1]) for s in session_log_data])
            }).sort_values(by="loggingTime", ascending=True)
            # Fuzzy merge on timestamps to map user logs to activity labels
            user_log_cleaned = pd.merge_asof(
                left=user_log_df,
                right=user_session_activity_df,
                on='loggingTime',
                direction='forward'
            )
            activity_data = pd.concat((activity_data, user_log_cleaned))
            
# In the end, you will have the fully cleaned and joined activity data file
activity_data.to_csv(r'/content/watch_activity_data.csv')

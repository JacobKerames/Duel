
import os
import turicreate as tc

# Column name mappings
cols = {
    "motionRotationRateX(rad/s)": "rotation_x",
    "motionRotationRateY(rad/s)": "rotation_y",
    "motionRotationRateZ(rad/s)": "rotation_z",
    "motionUserAccelerationX(G)": "acceleration_x",
    "motionUserAccelerationY(G)": "acceleration_y",
    "motionUserAccelerationZ(G)": "acceleration_z",
    "sessionId": "session_id",
    "activity": "activity"
}
csv_cols = ["rotation_x", "rotation_y", "rotation_z", "acceleration_x", "acceleration_y", "acceleration_z"]

# Load csv data and rename columns
sf = tc.SFrame.read_csv("watch_activity_data.csv")
[list(cols.keys())].rename(cols)

# Remove missing activies
sf = sf[sf['activity'] != '']
acts = sf['activity'].unique()

# Split data into training and testing sets
train, test = tc.activity_classifier.util.random_split_by_session(sf, session_id='session_id', fraction=0.8)

# Write out training data
path = "train/"
os.mkdir(path)

for a in acts:
    # Check for folder
    cls_path = path + a + "/"
    if not os.path.exists(cls_path):
        os.mkdir(cls_path)
    # Split data by activity & session and write to file
    sf_act = train[train['activity'] == a]
    for s in sf_act['session_id'].unique():
        sf_act[sf_act['session_id'] == s][csv_cols].save(cls_path + str(s) + ".csv")

# Write out testing data
path = "test/"
os.mkdir(path)

for a in acts:
    # Check for folder
    cls_path = path + a + "/"
    if not os.path.exists(cls_path):
        os.mkdir(cls_path)
    # Split data by activity & session and write to file
    sf_act = test[test['activity'] == a]
    for s in sf_act['session_id'].unique():
        sf_act[sf_act['session_id'] == s][csv_cols].save(cls_path + str(s) + ".csv")

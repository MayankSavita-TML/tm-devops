#!/usr/bin/env bash
# SEEDED FOR TRAINING — DO NOT USE, DO NOT REMOVE WITHOUT UPDATING TRAINING_SEEDS.md
#
# Simulates a legacy integration script that (badly) hardcodes credentials
# instead of reading them from the environment. This is the GitLeaks lab
# seed for OrderFlow-Lite — see TRAINING_SEEDS.md at the repo root.
#
# The key below is AWS's own published example Access Key ID
# (used throughout AWS documentation as a non-functional placeholder,
# e.g. https://docs.aws.amazon.com/IAM/latest/UserGuide/id_credentials_access-keys.html)
# It is not a real, active credential.

AWS_ACCESS_KEY_ID="AKIAIOSFODNN7EXAMPLE"

echo "Notifying legacy webhook with access key ${AWS_ACCESS_KEY_ID}..."

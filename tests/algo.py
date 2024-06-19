# Simulating and calculating a match and mismatch example

# Parameters for a good match
good_match_params = {
    "n": 10,
    "m": 8,
    "p": 7,
    "q": 5,
    "l": 4,
    "n_feedback": 3,
    "r": 6,
    "x": 60,  # High similarity score
    "alpha": 1.0,
    "beta": 0.8,
    "delta": 0.6,
    "theta": 1.2,
    "lambda_": 0.7,
    "mu": 0.5,
    "nu": 0.9,
    "gamma": 0.9
}

# Parameters for a poor match
poor_match_params = {
    "n": 10,
    "m": 8,
    "p": 7,
    "q": 5,
    "l": 4,
    "n_feedback": 3,
    "r": 6,
    "x": 20,  # Low similarity score
    "alpha": 1.0,
    "beta": 0.8,
    "delta": 0.6,
    "theta": 1.2,
    "lambda_": 0.7,
    "mu": 0.5,
    "nu": 0.9,
    "gamma": 0.9
}

# Calculate match score for good match
good_match_score = match_score(**good_match_params)

# Calculate match score for poor match
poor_match_score = match_score(**poor_match_params)

good_match_score, poor_match_score
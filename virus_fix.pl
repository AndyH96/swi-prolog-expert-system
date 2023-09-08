% Knowledge Base (Symptoms and Risk Factors)

% Define facts about symptoms and their severity
symptom(fever, mild).
symptom(dry_cough, mild).
symptom(tiredness, mild).
symptom(aches_and_pains, mild).
symptom(sore_throat, mild).
symptom(diarrhea, mild).
symptom(conjunctivitis, mild).
symptom(headache, moderate).
symptom(anosmia, moderate).
symptom(shortness_of_breath, severe).
symptom(chest_pain, severe).
symptom(loss_of_speech_or_movement, severe).

% Define risk factors for patients
risk_factor(age_above_70).
risk_factor(hypertension).
risk_factor(diabetes).
risk_factor(cardiovascular_disease).
risk_factor(chronic_respiratory_disease).
risk_factor(cancer).
risk_factor(male).
risk_factor(contact_with_infected).

% Define facts about transmission mechanisms and probabilities
transmission_mechanism(close_proximity, 0.3).
transmission_mechanism(respiratory_droplets, 0.6).
transmission_mechanism(surface_contamination, 0.1).

% Expert System Rules

% Define a predicate for gathering patient information
gather_patient_information(Patient, Symptoms, RiskFactors) :-
    gather_symptoms(Patient, Symptoms),
    gather_risk_factors(Patient, RiskFactors),
    diagnose_virus_infection(Patient, Symptoms, RiskFactors).

% Gather symptoms for a patient
gather_symptoms(Patient, Symptoms) :-
    writeln('Please answer the following questions about symptoms for the patient:'),
    ask_symptom(Patient, fever, Fever),
    ask_symptom(Patient, dry_cough, DryCough),
    % Add similar questions for other symptoms here
    parse_symptoms([Fever, DryCough, ...], Symptoms).

% Gather risk factors for a patient
gather_risk_factors(Patient, RiskFactors) :-
    writeln('Please answer the following questions about risk factors for the patient:'),
    ask_risk_factor(Patient, age_above_70, AgeAbove70),
    ask_risk_factor(Patient, hypertension, Hypertension),
    % Add similar questions for other risk factors here
    parse_risk_factors([AgeAbove70, Hypertension, ...], RiskFactors).

% Ask a single symptom question
ask_symptom(Patient, Symptom, Response) :-
    writeln('Does the patient have ')write(Symptom), write('? (yes/no)'),
    read_line_to_string(user_input, Response).

% Ask a single risk factor question
ask_risk_factor(Patient, Factor, Response) :-
    writeln('Does the patient have ')write(Factor), write('? (yes/no)'),
    read_line_to_string(user_input, Response).

% Parse symptom responses
parse_symptoms([], []).
parse_symptoms(['yes' | Rest], [Symptom | Symptoms]) :-
    symptom(Symptom, _),
    parse_symptoms(Rest, Symptoms).
parse_symptoms(['no' | Rest], Symptoms) :-
    parse_symptoms(Rest, Symptoms).
parse_symptoms([_ | Rest], Symptoms) :-
    writeln('Please answer with "yes" or "no".'),
    parse_symptoms(Rest, Symptoms).

% Parse risk factor responses
parse_risk_factors([], []).
parse_risk_factors(['yes' | Rest], [RiskFactor | RiskFactors]) :-
    risk_factor(RiskFactor),
    parse_risk_factors(Rest, RiskFactors).
parse_risk_factors(['no' | Rest], RiskFactors) :-
    parse_risk_factors(Rest, RiskFactors).
parse_risk_factors([_ | Rest], RiskFactors) :-
    writeln('Please answer with "yes" or "no".'),
    parse_risk_factors(Rest, RiskFactors).

% Diagnosis and Recovery Rules

% Define rules for diagnosis based on symptom severity
diagnose_virus_infection(Patient, Symptoms, RiskFactors) :-
    has_contact_history(Patient, ContactHistory),
    has_symptoms(Patient, Symptoms),
    has_risk_factors(Patient, RiskFactors),
    (severity(Symptoms, Severity), Severity == severe -> write('The patient is at high risk of having the virus infection. Seek immediate medical attention and follow medical guidance.');
    severity(Symptoms, Severity), Severity == moderate -> write('The patient may have the virus infection. Seek medical advice and follow medical guidance.');
    write('The patient may have the virus infection. Continue monitoring symptoms and follow medical guidance.')),
    recovery_and_hospitalization(Severity, ContactHistory).

diagnose_virus_infection(Patient, Symptoms, RiskFactors) :-
    has_contact_history(Patient, ContactHistory),
    has_symptoms(Patient, Symptoms),
    not(has_risk_factors(Patient, RiskFactors)),
    (severity(Symptoms, Severity), Severity == severe -> write('The patient may have the virus infection. Seek medical advice and follow medical guidance.');
    write('The patient may have the virus infection. Continue monitoring symptoms and follow medical guidance.')),
    recovery_and_hospitalization(Severity, ContactHistory).

diagnose_virus_infection(Patient, _, _) :-
    not(has_symptoms(Patient)),
    write('The patient is less likely to have the virus infection.'),
    recovery_and_hospitalization(none, no).

% Define rules for recovery and hospitalization
recovery_and_hospitalization(Severity, ContactHistory) :-
    (Severity == severe -> write('The patient with severe symptoms should seek immediate medical attention and hospitalization.');
    Severity == moderate -> 
        (ContactHistory == yes -> write('Patients with moderate symptoms and contact history may require hospitalization depending on their condition. Consult a medical professional.');
        write('Patients with moderate symptoms may require


% Knowledge Base

% Define facts about symptoms and risk factors
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
symptom(asymptomatic, none).

% Define risk factors for severe symptoms
risk_factor(age_above_70).
risk_factor(hypertension).
risk_factor(diabetes).
risk_factor(cardiovascular_disease).
risk_factor(chronic_respiratory_disease).
risk_factor(cancer).
risk_factor(male).

% Define transmission mechanisms and probabilities
transmission_mechanism(close_proximity, 0.6).
transmission_mechanism(respiratory_droplets, 0.9).
transmission_mechanism(surface_contamination, 0.3).

% Define survival time of the virus on different surfaces
virus_survival_time(copper, hours(6)).
virus_survival_time(cardboard, hours(12)).
virus_survival_time(plastic, days(2)).
virus_survival_time(stainless_steel, days(3)).

% Define the incubation period range (1 to 14 days)
incubation_period_range(1, 14).

% Interactive Diagnosis Code

% Define a predicate to start the diagnosis
start_diagnosis :-
    writeln('Welcome to the Virus Infection Diagnosis System.'),
    writeln('Please enter the patient\'s name:'),
    read_line_to_string(user_input, PatientName),
    ask_patient_questions(PatientName).

% Define a predicate to ask a series of questions to the patient
ask_patient_questions(PatientName) :-
    ask_contact_history(PatientName).

ask_contact_history(PatientName) :-
    writeln('Has the patient had close contact with an infected person in the last 14 days? (yes/no)'),
    read_line_to_string(user_input, ContactHistory),
    ask_symptoms(PatientName, ContactHistory).

ask_symptoms(PatientName, ContactHistory) :-
    writeln('Please enter the patient\'s symptoms separated by commas (e.g., fever, dry_cough, shortness_of_breath, loss_of_speech_or_movement):'),
    read_line_to_string(user_input, SymptomsInput),
    split_string(SymptomsInput, ",", " ", SymptomsList),
    ask_risk_factors(PatientName, ContactHistory, SymptomsList).

ask_risk_factors(PatientName, ContactHistory, SymptomsList) :-
    writeln('Please enter the patient\'s risk factors separated by commas (e.g., age_above_70, hypertension):'),
    read_line_to_string(user_input, RiskFactorsInput),
    split_string(RiskFactorsInput, ",", " ", RiskFactorsList),
    ask_age_and_gender(PatientName, ContactHistory, SymptomsList, RiskFactorsList).

ask_age_and_gender(PatientName, ContactHistory, SymptomsList, RiskFactorsList) :-
    writeln('Please enter the patient\'s age:'),
    read_line_to_string(user_input, AgeInput),
    atom_number(AgeInput, Age),
    writeln('Please enter the patient\'s gender (male/female):'),
    read_line_to_string(user_input, Gender),
    ask_recent_travel(PatientName, ContactHistory, SymptomsList, RiskFactorsList, [Age, Gender]).

ask_recent_travel(PatientName, ContactHistory, SymptomsList, RiskFactorsList, BioData) :-
    writeln('Does the patient have a recent travel history? (yes/no)'),
    read_line_to_string(user_input, RecentTravel),
    diagnose_and_recommend(PatientName, SymptomsList, RiskFactorsList, BioData, RecentTravel).

% Define a predicate to calculate severity based on symptoms
severity(SymptomsList, Severity) :-
    count_severe_symptoms(SymptomsList, SevereCount),
    count_moderate_symptoms(SymptomsList, ModerateCount),
    count_mild_symptoms(SymptomsList, MildCount),
    determine_severity(SevereCount, ModerateCount, MildCount, Severity).

count_severe_symptoms(SymptomsList, Count) :-
    include(severe_symptom, SymptomsList, SevereSymptoms),
    length(SevereSymptoms, Count).

count_moderate_symptoms(SymptomsList, Count) :-
    include(moderate_symptom, SymptomsList, ModerateSymptoms),
    length(ModerateSymptoms, Count).

count_mild_symptoms(SymptomsList, Count) :-
    include(mild_symptom, SymptomsList, MildSymptoms),
    length(MildSymptoms, Count).

severe_symptom(Symptom) :-
    symptom(Symptom, severe).

moderate_symptom(Symptom) :-
    symptom(Symptom, moderate).

mild_symptom(Symptom) :-
    symptom(Symptom, mild).

determine_severity(SevereCount, _, _, severe) :-
    SevereCount >= 2.  % Define your criteria for severe symptoms.
determine_severity(_, ModerateCount, _, moderate) :-
    ModerateCount >= 2.  % Define your criteria for moderate symptoms.
determine_severity(_, _, _, mild).

% Define a predicate to diagnose and recommend based on patient data
diagnose_and_recommend(PatientName, SymptomsList, RiskFactorsList, BioData, RecentTravel) :-
    % Calculate severity based on symptoms
    severity(SymptomsList, Severity),

    % Determine diagnosis message based on severity and contact history
    diagnosis_message(PatientName, SymptomsList, Severity, RecentTravel),

    % Process age, gender, and risk factors for recovery and hospitalization recommendations
    process_bio_data(PatientName, BioData, Age),
    process_history(PatientName, RecentTravel, Severity, Age, RiskFactorsList).

% Define a predicate to process bio data for the patient (e.g., age, gender)
process_bio_data(PatientName, _, Age) :-
    % Example: Extract age from BioData (replace with actual data retrieval)
    extract_age(PatientName, Age).

% Define a predicate to process history of events for the patient (e.g., recent travel, exposure)
process_history(PatientName, RecentTravel, Severity, Age, RiskFactorsList) :-
    % Example: Check for recent travel in History (replace with actual data retrieval)
    check_for_recent_travel(PatientName, RecentTravel),
    recovery_and_hospitalization(Severity, Age, RiskFactorsList).

% Example: Extract age from BioData (assumed)
extract_age(john, 75).
extract_age(alice, 28).
extract_age(bob, 62).
extract_age(carol, 35).

% Example: Check for recent travel in History (assumed)
check_for_recent_travel(john, yes).
check_for_recent_travel(alice, no).
check_for_recent_travel(bob, yes).
check_for_recent_travel(carol, yes).

% Define facts about symptoms for each patient
has_symptoms(john, [fever, dry_cough, tiredness, shortness_of_breath]).
has_symptoms(alice, [fever, dry_cough, sore_throat]).
has_symptoms(bob, [shortness_of_breath, chest_pain, headache, tiredness]).
has_symptoms(carol, [asymptomatic]).

% Define facts about risk factors for each patient
has_risk_factors(john, [age_above_70, hypertension, male]).
has_risk_factors(alice, [diabetes, cancer]).
has_risk_factors(bob, [hypertension, cardiovascular_disease, male]).
has_risk_factors(carol, [chronic_respiratory_disease]).

% Define rules for handling different severity levels
diagnosis_message(_, _, severe, yes) :-
    write('The patient is at high risk of having a severe virus infection. Seek immediate medical attention and follow medical guidance.').
diagnosis_message(_, _, severe, no) :-
    write('The patient is at a moderately high risk of having a severe virus infection. Please kindly seek medical attention and follow medical guidance.').
diagnosis_message(_, _, moderate, yes) :-
    write('The patient may have a moderate virus infection. Seek medical advice and follow medical guidance.').
diagnosis_message(_, _, moderate, no) :-
    write('The patient may have a moderate virus infection. Seek medical advice and follow medical guidance.').
diagnosis_message(_, _, mild, yes) :-
    write('The patient may have a mild virus infection. Continue monitoring symptoms and follow medical guidance.').
diagnosis_message(_, _, mild, no) :-
    write('The patient may have a mild virus infection. Continue monitoring symptoms and follow medical guidance.').
diagnosis_message(_, _, _, _) :-
    write('The patient is less likely to have the virus infection.').

% Define rules for recovery and hospitalization
recovery_and_hospitalization(severe, Age, RiskFactorsList) :-
    (member(age_above_70, RiskFactorsList); (member(male, RiskFactorsList), member([hypertension, diabetes, cardiovascular_disease, chronic_respiratory_disease, cancer], RiskFactorsList))),
    write('The patient with severe symptoms, advanced age, or pre-existing health conditions should seek immediate medical attention and hospitalization.').
recovery_and_hospitalization(moderate, Age, RiskFactorsList) :-
    (member(age_above_70, RiskFactorsList); (member(male, RiskFactorsList), member([hypertension, diabetes, cardiovascular_disease, chronic_respiratory_disease, cancer], RiskFactorsList))),
    write('The patient with moderate symptoms, advanced age, or pre-existing health conditions may require hospitalization depending on their condition. Consult a medical professional.').
recovery_and_hospitalization(_, Age, _) :-
    Age >= 70,
    write('Patients above 70 years old should consult a doctor even for mild symptoms.').
recovery_and_hospitalization(_, _, Gender) :-
    Gender == male,
    write('Male patients with symptoms and recent travel history should consult a doctor.').
recovery_and_hospitalization(_, _, _) :-
    write('Patients with mild symptoms can recover at home. Get plenty of rest, stay hydrated, and consult a doctor if symptoms worsen or persist.').

% Run the interactive diagnosis program
:- dynamic has_symptoms/2, has_risk_factors/2. % To allow dynamic facts
start_diagnosis.
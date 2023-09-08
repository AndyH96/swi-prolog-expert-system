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

% Expert System

% Define rules for diagnosis based on symptoms and risk factors
diagnose_virus_infection(Patient, Symptoms, RiskFactors, BioData, History) :-
    has_contact_history(Patient, ContactHistory),
    parse_symptoms(Patient, Symptoms), % Updated predicate
    parse_risk_factors(Patient, RiskFactors), % Updated predicate
    severity(Symptoms, Severity),
    diagnosis_message(Severity, ContactHistory),
    process_bio_data(Patient, BioData, Age),
    process_history(Patient, History, RecentTravel),
    recovery_and_hospitalization(Severity, Age, RiskFactors, Gender, RecentTravel).

% Define a rule to parse symptoms for a patient
parse_symptoms(Patient, Symptoms) :-
    has_symptoms(Patient, Symptoms).

% Define a rule to parse risk factors for a patient
parse_risk_factors(Patient, RiskFactors) :-
    has_risk_factors(Patient, RiskFactors).

% Rules for handling different severity levels
diagnosis_message(severe, yes) :-
    write('The patient is at high risk of having a severe virus infection. Seek immediate medical attention and follow medical guidance.').
diagnosis_message(moderate, yes) :-
    write('The patient may have a moderate virus infection. Seek medical advice and follow medical guidance.').
diagnosis_message(mild, yes) :-
    write('The patient may have a mild virus infection. Continue monitoring symptoms and follow medical guidance.').
diagnosis_message(_, no) :-
    write('The patient is less likely to have the virus infection.').

% Define rules for recovery and hospitalization
recovery_and_hospitalization(severe, _, RiskFactors, Gender, yes) :-
    (member(age_above_70, RiskFactors); (member(male, RiskFactors), member([hypertension, diabetes, cardiovascular_disease, chronic_respiratory_disease, cancer], RiskFactors))),
    write('The patient with severe symptoms, advanced age, or pre-existing health conditions should seek immediate medical attention and hospitalization.').
recovery_and_hospitalization(moderate, _, RiskFactors, Gender, yes) :-
    (member(age_above_70, RiskFactors); (member(male, RiskFactors), member([hypertension, diabetes, cardiovascular_disease, chronic_respiratory_disease, cancer], RiskFactors))),
    write('The patient with moderate symptoms, advanced age, or pre-existing health conditions may require hospitalization depending on their condition. Consult a medical professional.').
recovery_and_hospitalization(_, Age, _, _, _) :-
    Age >= 70,
    write('Patients above 70 years old should consult a doctor even for mild symptoms.').
recovery_and_hospitalization(_, _, _, male, yes) :-
    write('Male patients with symptoms and recent travel history should consult a doctor.').
recovery_and_hospitalization(_, _, _, _, _) :-
    write('Patients with mild symptoms can recover at home. Get plenty of rest, stay hydrated, and consult a doctor if symptoms worsen or persist.').

% Process bio data for the patient (e.g., age, gender)
process_bio_data(Patient, _, Age) :-
    % Example: Extract age from BioData
    extract_age(Patient, Age).

% Example: Extract age from BioData (assumed)
extract_age(john, 45).
extract_age(alice, 28).
extract_age(bob, 62).
extract_age(carol, 35).

% Process history of events for the patient (e.g., recent travel, exposure)
process_history(Patient, _, RecentTravel) :-
    % Example: Check for recent travel in History
    check_for_recent_travel(Patient, RecentTravel).

% Example: Check for recent travel in History (assumed)
check_for_recent_travel(john, yes).
check_for_recent_travel(alice, no).
check_for_recent_travel(bob, yes).
check_for_recent_travel(carol, yes).

% Additional rules for diagnosis
has_contact_history(Patient, Answer) :-
    writeln('Has the patient had close contact with an infected person in the last 14 days? (yes/no)'),
    read_line_to_string(user_input, Answer).

% Define facts about symptoms for each patient
has_symptoms(john, [fever, dry_cough, tiredness]).
has_symptoms(alice, [fever, dry_cough, sore_throat]).
has_symptoms(bob, [shortness_of_breath, chest_pain, headache, tiredness]).
has_symptoms(carol, [fever, dry_cough, aches_and_pains, tiredness]).
% Define symptoms for other patients if needed.

% Define facts about risk factors for each patient
has_risk_factors(john, [age_above_70, hypertension]).
has_risk_factors(alice, [diabetes, cancer]).
has_risk_factors(bob, [age_above_70, hypertension, cardiovascular_disease, male]).
has_risk_factors(carol, [chronic_respiratory_disease]).
% Define risk factors for other patients if needed.

% Simulate virus transmission (not implemented based on the scenario)
% You can implement this if needed based on your requirements.

% Interactive Diagnosis Code (Add this part at the end of your file)
% Define a predicate to start the diagnosis

start_diagnosis :-
    writeln('Welcome to the Virus Infection Diagnosis System.'),
    writeln('Please enter the patient\'s name:'),
    read_line_to_string(user_input, PatientName),
    ask_for_contact_history(PatientName).

% Define predicates to ask for patient information
ask_for_contact_history(PatientName) :-
    writeln('Has the patient had close contact with an infected person in the last 14 days? (yes/no)'),
    read_line_to_string(user_input, ContactHistory),
    ask_for_symptoms(PatientName, ContactHistory).

ask_for_symptoms(PatientName, ContactHistory) :-
    writeln('Please enter the patient\'s symptoms separated by commas (e.g., fever, dry_cough, tiredness):'),
    read_line_to_string(user_input, SymptomsInput),
    split_string(SymptomsInput, ",", " ", SymptomsList),
    ask_for_risk_factors(PatientName, ContactHistory, SymptomsList).

ask_for_risk_factors(PatientName, ContactHistory, SymptomsList) :-
    writeln('Please enter the patient\'s risk factors separated by commas (e.g., age_above_70, hypertension):'),
    read_line_to_string(user_input, RiskFactorsInput),
    split_string(RiskFactorsInput, ",", " ", RiskFactorsList),
    ask_for_age_and_gender(PatientName, ContactHistory, SymptomsList, RiskFactorsList).

ask_for_age_and_gender(PatientName, ContactHistory, SymptomsList, RiskFactorsList) :-
    writeln('Please enter the patient\'s age:'),
    read_line_to_string(user_input, AgeInput),
    atom_number(AgeInput, Age),
    writeln('Please enter the patient\'s gender (male/female):'),
    read_line_to_string(user_input, Gender),
    ask_for_recent_travel(PatientName, ContactHistory, SymptomsList, RiskFactorsList, [Age, Gender]).

ask_for_recent_travel(PatientName, ContactHistory, SymptomsList, RiskFactorsList, BioData) :-
    writeln('Does the patient have a recent travel history? (yes/no)'),
    read_line_to_string(user_input, RecentTravel),
    diagnose_virus_infection(PatientName, SymptomsList, RiskFactorsList, BioData, RecentTravel),
    get_diagnosis_result(PatientName).

% Define a predicate to get the diagnosis result
get_diagnosis_result(PatientName) :-
    writeln('Diagnosis Result:'),
    % You can print the diagnosis result here based on the patient's information.
    restart_or_exit.

% Define a predicate to restart or exit the program
restart_or_exit :-
    writeln('Do you want to diagnose another patient? (yes/no)'),
    read_line_to_string(user_input, Answer),
    (Answer == "yes" -> start_diagnosis; writeln('Goodbye!')).

% Run the interactive diagnosis program
:- dynamic has_symptoms/2, has_risk_factors/2. % To allow dynamic facts
start_diagnosis.



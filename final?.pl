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
    parse_symptoms([Fever, DryCough, Tiredness, AchesAndPains, SoreThroat, Diarrhea, Conjunctivitis, Headache, Anosmia | MoreSymptoms], Symptoms),
    parse_risk_factors([AgeAbove70, Hypertension, Diabetes, CardiovascularDisease, ChronicRespiratoryDisease, Cancer, Gender | MoreRiskFactors], RiskFactors),
    severity(Symptoms, Severity),
    diagnosis_message(Severity, ContactHistory),
    process_bio_data(Patient, BioData, Age),
    process_history(Patient, History, RecentTravel),
    recovery_and_hospitalization(Severity, Age, RiskFactors, Gender, RecentTravel).

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
recovery_and_hospitalization(_, Age, _, Gender, _) :-
    Age >= 70,
    write('Patients above 70 years old should consult a doctor even for mild symptoms.').
recovery_and_hospitalization(_, _, _, male, yes) :-
    write('Male patients with symptoms and recent travel history should consult a doctor.').
recovery_and_hospitalization(_, _, _, _, _) :-
    write('Patients with mild symptoms can recover at home. Get plenty of rest, stay hydrated, and consult a doctor if symptoms worsen or persist.').

% Process bio data for the patient (e.g., age, gender)
process_bio_data(Patient, BioData, Age) :-
    % Example: Extract age from BioData
    extract_age(Patient, BioData, Age).

% Example: Extract age from BioData (assumed)
extract_age(john, BioData, 45).
extract_age(alice, BioData, 28).
extract_age(bob, BioData, 62).
extract_age(carol, BioData, 35).

% Process history of events for the patient (e.g., recent travel, exposure)
process_history(Patient, History, RecentTravel) :-
    % Example: Check for recent travel in History
    check_for_recent_travel(Patient, History, RecentTravel).

% Example: Check for recent travel in History (assumed)
check_for_recent_travel(john, History, yes).
check_for_recent_travel(alice, History, no).
check_for_recent_travel(bob, History, yes).
check_for_recent_travel(carol, History, yes).

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

% Simulate virus transmission (not implemented based on the scenario)
% You can implement this if needed based on your requirements.


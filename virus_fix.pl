% Establishing Knowledge Base

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

% Define risk factors for other patients if needed.
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

% Establishing Expert System

% Define rules for diagnosis based on symptom severity
diagnose_virus_infection(Patient, Symptoms, RiskFactors, BioData, History) :-
    has_contact_history(Patient, ContactHistory),
    parse_symptoms([Fever, DryCough, SoreThroat, Diarrhea, Conjunctivitis, Headache, Anosmia, ...], Symptoms),
    parse_risk_factors([AgeAbove70, Hypertension, Diabetes, CardiovascularDisease, ChronicRespiratoryDisease, Cancer, ...], RiskFactors),
    (severity(Symptoms, Severity), Severity == severe -> write('The patient is at high risk of having the virus infection. Seek immediate medical attention and follow medical guidance.');
    severity(Symptoms, Severity), Severity == moderate -> write('The patient may have the virus infection. Seek medical advice and follow medical guidance.');
    write('The patient may have the virus infection. Continue monitoring symptoms and follow medical guidance.')),
    process_bio_data(Patient, BioData),
    process_history(Patient, History),
    recovery_and_hospitalization(Severity, ContactHistory).

diagnose_virus_infection(Patient, Symptoms, RiskFactors, BioData, History) :-
    has_contact_history(Patient, ContactHistory),
    parse_symptoms([Fever, DryCough, SoreThroat, Diarrhea, Conjunctivitis, Headache, Anosmia, ...], Symptoms),
    parse_risk_factors([AgeAbove70, Hypertension, Diabetes, CardiovascularDisease, ChronicRespiratoryDisease, Cancer, ...], RiskFactors),
    not(has_risk_factors(Patient, RiskFactors)),
    (severity(Symptoms, Severity), Severity == severe -> write('The patient may have the virus infection. Seek medical advice and follow medical guidance.');
    write('The patient may have the virus infection. Continue monitoring symptoms and follow medical guidance.')),
    process_bio_data(Patient, BioData),
    process_history(Patient, History),
    recovery_and_hospitalization(Severity, ContactHistory).

diagnose_virus_infection(Patient, _, _, BioData, History) :-
    not(has_symptoms(Patient)),
    process_bio_data(Patient, BioData),
    process_history(Patient, History),
    write('The patient is less likely to have the virus infection.'),
    recovery_and_hospitalization(none, no).

% Define rules for recovery and hospitalization
recovery_and_hospitalization(Severity, ContactHistory) :-
    (Severity == severe -> write('The patient with severe symptoms should seek immediate medical attention and hospitalization.');
    Severity == moderate -> 
        (ContactHistory == yes -> write('Patients with moderate symptoms and contact history may require hospitalization depending on their condition. Consult a medical professional.');
        write('Patients with moderate symptoms may require hospitalization depending on their condition. Consult a medical professional.'));
    write('Patients with mild symptoms can recover at home. Get plenty of rest, stay hydrated, and consult a doctor if symptoms worsen or persist.')).

% Define severity based on symptoms
severity(Symptoms, Severity) :-
    count_severe_symptoms(Symptoms, Count),
    (Count >= 3 -> Severity = severe;
    Count >= 1 -> Severity = moderate;
    Severity = mild).

count_severe_symptoms(Symptoms, Count) :-
    severe_symptoms(SevereSymptoms),
    intersection(Symptoms, SevereSymptoms, Common),
    length(Common, Count).

severe_symptoms([shortness_of_breath, chest_pain, loss_of_speech_or_movement]).

% Process bio data for the patient (e.g., age, gender)
process_bio_data(Patient, BioData) :-
    % Add logic to process bio data here based on patient's information
    % Example: Extract age, gender, etc. from BioData.

% Process history of events for the patient (e.g., recent travel, exposure)
process_history(Patient, History) :-
    % Add logic to process history of events here based on patient's information
    % Example: Check for recent travel, exposure, etc. in History.

% Additional rules for diagnosis
has_contact_history(Patient, Answer) :-
    writeln('Has the patient had close contact with a confirmed virus case in the last 14 days? (yes/no)'),
    read_line_to_string(user_input, Answer).

% Define facts about symptoms for each patient
has_symptoms(john, [fever, dry_cough, tiredness]).
% Define symptoms for other patients if needed.

% Simulate virus transmission
transmit_virus(Patient1, Patient2, IncubationPeriod) :-
    has_virus(Patient1, IncubationPeriod),
    transmission_mechanism(Mechanism, Probability),
    random(X),
    (X < Probability -> infect(Patient2, IncubationPeriod); true).

% Define infection with incubation period and symptom severity
infect(Patient, IncubationPeriod) :-
    random(X),
    (X < 0.4 -> random_symptom_severity(Severity), assert(has_virus(Patient, IncubationPeriod, Severity)); true).

% Define random symptom severity
random_symptom_severity(Severity) :-
    random(X),
    (X < 0.2 -> Severity = severe;
    X < 0.7 -> Severity = moderate;
    Severity = mild).

% Define facts about risk factors for patients
has_risk_factors(john, [age_above_70, male, contact_with_infected]).
% Define risk factors for other patients if needed.

patient_data(john, [age(45), gender(male), medical_history([hypertension])]).

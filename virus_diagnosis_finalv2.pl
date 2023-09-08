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

% Define facts about risk factors for each patient
has_risk_factors(john, [age_above_70, male, contact_with_infected]).
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
diagnose_virus_infection(Patient, Symptoms, RiskFactors) :-
    has_contact_history(Patient),
    has_symptoms(Patient, Symptoms),
    has_risk_factors(Patient, RiskFactors),
    (severity(Symptoms, Severity), Severity == severe -> write('The patient is at high risk of having the virus infection. Seek immediate medical attention and follow medical guidance.');
    severity(Symptoms, Severity), Severity == moderate -> write('The patient may have the virus infection. Seek medical advice and follow medical guidance.');
    write('The patient may have the virus infection. Continue monitoring symptoms and follow medical guidance.')),
    recovery_and_hospitalization(Severity).

diagnose_virus_infection(Patient, Symptoms, RiskFactors) :-
    has_contact_history(Patient),
    has_symptoms(Patient, Symptoms),
    not(has_risk_factors(Patient, RiskFactors)),
    (severity(Symptoms, Severity), Severity == severe -> write('The patient may have the virus infection. Seek medical advice and follow medical guidance.');
    write('The patient may have the virus infection. Continue monitoring symptoms and follow medical guidance.')),
    recovery_and_hospitalization(Severity).

diagnose_virus_infection(Patient, _, _) :-
    not(has_symptoms(Patient)),
    write('The patient is less likely to have the virus infection.'),
    recovery_and_hospitalization(none).

% Define rules for recovery and hospitalization
recovery_and_hospitalization(Severity) :-
    (Severity == severe -> write('The patient with severe symptoms should seek immediate medical attention and hospitalization.');
    Severity == moderate -> write('Patients with moderate symptoms may require hospitalization depending on their condition. Consult a medical professional.');
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

% Additional rules for diagnosis
has_contact_history(Patient) :-
    writeln('Has the patient had close contact with a confirmed virus case in the last 14 days? (yes/no)'),
    read_line_to_string(user_input, Answer),
    (Answer == "yes" -> true; Answer == "no" -> true; false).

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

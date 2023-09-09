%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Knowledge Base %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
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

% Dynamic Facts for Patient Data
:- dynamic has_symptoms/2, has_risk_factors/2.

% Example: Extract age from BioData (assumed)
extract_age(john, 75).
extract_age(alice, 28).
extract_age(bob, 62).
extract_age(carol, 35).

% Define facts about symptoms for each patient
has_symptoms(john, [fever, dry_cough, tiredness, shortness_of_breath, chest_pain,]).
has_symptoms(alice, [fever, dry_cough, sore_throat]).
has_symptoms(bob, [anosmia]).
has_symptoms(carol, [asymptomatic]).

% Define facts about risk factors for each patient
has_risk_factors(john, [age_above_70, hypertension,cardiovascular_disease, male]).
has_risk_factors(alice, [diabetes, cancer]).
has_risk_factors(bob, [male]).
has_risk_factors(carol, [chronic_respiratory_disease]).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Interactive Diagnosis Code %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Define a predicate to start the diagnosis
start_diagnosis :-
    writeln('Welcome to the Virus Infection Diagnosis System.'),
    writeln('Please enter the patient\'s name:'),
    read_line_to_string(user_input, PatientName),
    ask_patient_questions(PatientName).

% Define a predicate to ask a series of questions to the patient
ask_patient_questions(PatientName) :-
    writeln('Do you want to provide new information about the patient\'s symptoms and risk factors? (yes/no)'),
    read_line_to_string(user_input, Response),
    (Response = 'yes' ->
        ask_symptoms(PatientName)
    ;   ask_contact_history(PatientName)
    ).

ask_contact_history(PatientName) :-
    writeln('Has the patient had close contact with an infected person in the last 14 days (within the typical incubation period)? (yes/no)'),
    read_line_to_string(user_input, ContactHistory),
    ask_symptoms(PatientName, ContactHistory).

% Define a predicate to ask for symptoms and process the input
ask_symptoms(PatientName, ContactHistory) :-
    writeln('What are the patient\'s symptoms?'),
    display_symptom_options,
    read_line_to_string(user_input, SymptomsInput),
    process_symptoms_input(PatientName, ContactHistory, SymptomsInput).

% Display the list of symptom options to the user
display_symptom_options :-
    writeln('Select all that apply separated by commas:'),
    writeln('1. Fever'),
    writeln('2. Dry cough'),
    writeln('3. Tiredness'),
    writeln('4. Aches and pains'),
    writeln('5. Sore throat'),
    writeln('6. Diarrhea'),
    writeln('7. Conjunctivitis'),
    writeln('8. Headache'),
    writeln('9. Anosmia'),
    writeln('10. Shortness of breath'),
    writeln('11. Chest pain'),
    writeln('12. Loss of speech or movement'),
    writeln('13. Asymptomatic').

% Process the input for symptoms
process_symptoms_input(PatientName, ContactHistory, SymptomsInput) :-
    % Convert the input to lowercase and split
    downcase_atom(SymptomsInput, LowercaseSymptomsInput),
    split_string(LowercaseSymptomsInput, ",", " ", SymptomsList),
    remove_symptoms(PatientName),  % Remove previous symptoms if any
    add_symptoms(PatientName, SymptomsList),
    ask_risk_factors(PatientName, ContactHistory).

% Define a predicate to ask for risk factors and process the input
ask_risk_factors(PatientName, ContactHistory) :-
    writeln('Please enter the patient\'s risk factors:'),
    display_risk_factors,  % Display the list of risk factor options
    read_line_to_string(user_input, RiskFactorsInput),
    process_risk_factors_input(PatientName, ContactHistory, RiskFactorsInput).

% Display the list of risk factor options to the user
display_risk_factors :-
    writeln('Select all that apply, separated by commas(e.g., age_above_70, hypertension):'),
    writeln('1. Age above 70'),
    writeln('2. Hypertension'),
    writeln('3. Diabetes'),
    writeln('4. Cardiovascular disease'),
    writeln('5. Chronic respiratory disease'),
    writeln('6. Cancer'),
    writeln('7. Male').

% Process the input for risk factors
process_risk_factors_input(PatientName, ContactHistory, RiskFactorsInput) :-
    % Convert the input to lowercase and split
    downcase_atom(RiskFactorsInput, LowercaseRiskFactorsInput),
    split_string(LowercaseRiskFactorsInput, ",", " ", RiskFactorsList),
    remove_risk_factors(PatientName),  % Remove previous risk factors if any
    add_risk_factors(PatientName, RiskFactorsList),
    ask_age_and_gender(PatientName, ContactHistory).


ask_age_and_gender(PatientName, ContactHistory) :-
    writeln('Please enter the patient\'s age:'),
    read_line_to_string(user_input, AgeInput),
    atom_number(AgeInput, Age),
    writeln('Please enter the patient\'s gender (male/female):'),
    read_line_to_string(user_input, Gender),
    ask_recent_travel(PatientName, ContactHistory, [Age, Gender]).

ask_recent_travel(PatientName, ContactHistory, BioData) :-
    writeln('Does the patient have a recent travel history? (yes/no)'),
    read_line_to_string(user_input, RecentTravel),
    diagnose_and_recommend(PatientName, ContactHistory, BioData, RecentTravel).

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

% Define a predicate to determine severity based on symptoms
determine_severity(SevereCount, _, 1, mild) :-
    SevereCount = 0, !.  % If there is exactly 1 mild symptom and no severe symptoms, treat as mild.
determine_severity(SevereCount, _, MildCount, mild) :-
    SevereCount = 0,     % If there are no severe symptoms and not 3+ mild symptoms, treat as mild.
    MildCount >= 1, !.
determine_severity(SevereCount, _, MildCount, severe) :-
    SevereCount >= 1.    % If there is at least one severe symptom, treat as severe.
determine_severity(_, _, MildCount, severe) :-
    MildCount >= 3.      % If at least 3 mild symptoms are present, treat as severe.
determine_severity(_, ModerateCount, _, moderate) :-
    ModerateCount >= 1.  % Define your criteria for moderate symptoms.

determine_severity(_, _, _, mild).

% Define a predicate to determine recovery and hospitalization recommendations
recovery_and_hospitalization(Severity, Age, RiskFactorsList) :-
    (   Severity = severe,
        (   member(age_above_70, RiskFactorsList)
        ;   member(hypertension, RiskFactorsList)
        ;   member(cardiovascular_disease, RiskFactorsList)
        ),
        Age >= 60
    ->  writeln('Recommend hospitalization and immediate medical attention.')
    ;   Severity = moderate
    ->  writeln('Recommend medical advice and monitoring at home.')
    ;   Severity = mild
    ->  writeln('Recommend home isolation and monitoring.')
    ;   writeln('Recommend regular monitoring and follow medical guidance.')
    ).

% Define a predicate to diagnose and recommend based on patient data
diagnose_and_recommend(PatientName, ContactHistory, BioData, RecentTravel) :-
    % Get symptoms and risk factors for the patient
    has_symptoms(PatientName, SymptomsList),
    has_risk_factors(PatientName, RiskFactorsList),

    % Calculate severity based on symptoms
    severity(SymptomsList, Severity),

    % Process age, gender, and risk factors for recovery and hospitalization recommendations
    process_bio_data(PatientName, BioData, Age),
    process_history(PatientName, RecentTravel, Severity, Age, RiskFactorsList),

    % Determine diagnosis message based on severity and contact history
    diagnosis_message(PatientName, SymptomsList, Severity, ContactHistory, RecentTravel).

% Define a predicate to process bio data for the patient (e.g., age, gender)
process_bio_data(PatientName, _, Age) :-
    % Example: Extract age from BioData (replace with actual data retrieval)
    extract_age(PatientName, Age).

% Define diagnosis message for mild severity
diagnosis_message(_, _, mild, _, _) :-
    write('The patient may have a mild virus infection. Continue monitoring symptoms and follow medical guidance.').

% Define diagnosis message for moderate severity
diagnosis_message(_, _, moderate, _, _) :-
    write('The patient may have a moderate virus infection. Seek medical advice and follow medical guidance.').

% Define diagnosis message for severe severity
diagnosis_message(_, _, severe, _, _) :-
    write('The patient is at high risk of having a severe virus infection. Seek immediate medical attention and follow medical guidance.').

% Default diagnosis message (if none of the above conditions match)
diagnosis_message(_, _, _, _, _) :-
    write('The patient is less likely to have the virus infection. Continue monitoring symptoms and follow medical guidance.').

% Define predicates to add and retract symptoms and risk factors for a patient
add_symptoms(PatientName, SymptomsList) :-
    assertz(has_symptoms(PatientName, SymptomsList)).

remove_symptoms(PatientName) :-
    retract(has_symptoms(PatientName, _)).

add_risk_factors(PatientName, RiskFactorsList) :-
    assertz(has_risk_factors(PatientName, RiskFactorsList)).

remove_risk_factors(PatientName) :-
    retract(has_risk_factors(PatientName, _)).

% Run the interactive diagnosis program
% :- start_diagnosis.

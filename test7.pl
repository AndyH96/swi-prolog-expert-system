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

% Example: Extract age from patients
extract_age(john, 75).
extract_age(alice, 28).
extract_age(bob, 62).
extract_age(carol, 35).

% Example: Define facts about symptoms for each patient
has_symptoms(john, [fever, dry_cough, tiredness, shortness_of_breath, chest_pain]).
has_symptoms(alice, [fever, dry_cough, sore_throat]).
has_symptoms(bob, [anosmia]).
has_symptoms(carol, [asymptomatic]).

% Example: Define facts about risk factors for each patient
has_risk_factors(john, [age_above_70, hypertension, cardiovascular_disease, male]).
has_risk_factors(alice, [diabetes, cancer]).
has_risk_factors(bob, [male]).
has_risk_factors(carol, [chronic_respiratory_disease]).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Interactive Diagnosis Code %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Define a predicate to trim leading and trailing spaces from a string
string_trim(String, Trimmed) :-
    atom_codes(String, Codes),
    trim_spaces(Codes, TrimmedCodes),
    atom_codes(Trimmed, TrimmedCodes).

% Define a predicate to trim spaces from the beginning of a list
trim_spaces([], []).

trim_spaces([32 | Rest], Trimmed) :-  % 32 is the ASCII code for space
    trim_spaces(Rest, Trimmed).

trim_spaces(Trimmed, Trimmed).

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
    process_symptoms(PatientName, ContactHistory, SymptomsInput),
    ask_risk_factors(PatientName, ContactHistory).

% Display the list of symptom options to the user
display_symptom_options :-
    writeln('Select all that apply separated by commas with no spaces:'),
    writeln('- Fever'),
    writeln('- Dry cough'),
    writeln('- Tiredness'),
    writeln('- Aches and pains'),
    writeln('- Sore throat'),
    writeln('- Diarrhea'),
    writeln('- Conjunctivitis'),
    writeln('- Headache'),
    writeln('- Anosmia'),
    writeln('- Shortness of breath'),
    writeln('- Chest pain'),
    writeln('- Loss of speech or movement'),
    writeln('- Asymptomatic').

% Define a predicate to process the input for symptoms
process_symptoms(PatientName, ContactHistory, SymptomsInput) :-
    atom_string(SymptomsAtom, SymptomsInput),
    atomic_list_concat(SymptomsList, ',', SymptomsAtom),
    process_symptoms_list(PatientName, ContactHistory, SymptomsList),
    ask_risk_factors(PatientName, ContactHistory).

% Define a predicate to process a list of symptoms
process_symptoms_list(_, _, []) :- !.  % No more symptoms to process
process_symptoms_list(PatientName, ContactHistory, [Symptom | Rest]) :-
    atom_trim(Symptom, TrimmedSymptom),  % Remove leading/trailing spaces
    (symptom(TrimmedSymptom, _) ->
        assertz(has_symptoms(PatientName, [TrimmedSymptom | Rest])),
        process_symptoms_list(PatientName, ContactHistory, Rest)
    ;   writeln('Invalid symptom detected. Please enter valid symptoms.'),  % Invalid symptom, show a message
        ask_symptoms(PatientName, ContactHistory)
    ).

% Define a predicate to trim leading and trailing spaces from an atom
atom_trim(Atom, Trimmed) :-
    atom_string(Atom, String),
    string_trim(String, TrimmedString),
    atom_string(Trimmed, TrimmedString).

% Define a predicate to ask for risk factors and process the input
ask_risk_factors(PatientName, ContactHistory) :-
    writeln('Please enter the patient\'s risk factors:'),
    display_risk_factors,  % Display the list of risk factor options
    read_line_to_string(user_input, RiskFactorsInput),
    process_risk_factors_input(PatientName, ContactHistory, RiskFactorsInput).

% Display the list of risk factor options to the user
display_risk_factors :-
    writeln('Select all that apply, separated by commas with no spaces (e.g., age_above_70,hypertension):'),
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

% Define predicates to append and retract risk factors for a patient
add_risk_factors(PatientName, RiskFactorsList) :-
    assertz(has_risk_factors(PatientName, RiskFactorsList)).

remove_risk_factors(PatientName) :-
    retract(has_risk_factors(PatientName, _)).

% Define a predicate to ask for age and gender
ask_age_and_gender(PatientName, ContactHistory) :-
    writeln('Please enter the patient\'s age:'),
    read_line_to_string(user_input, AgeInput),
    atom_number(AgeInput, Age),
    writeln('Please enter the patient\'s gender (male/female):'),
    read_line_to_string(user_input, Gender),
    ask_recent_travel(PatientName, ContactHistory, [Age, Gender]).

% Define a predicate to ask about recent travel history
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

% Define a predicate to count severe symptoms
count_severe_symptoms(SymptomsList, SevereCount) :-
    include(severe_symptom, SymptomsList, SevereSymptoms),
    length(SevereSymptoms, SevereCount).

% Define a predicate to count moderate symptoms
count_moderate_symptoms(SymptomsList, ModerateCount) :-
    include(moderate_symptom, SymptomsList, ModerateSymptoms),
    length(ModerateSymptoms, ModerateCount).

% Define a predicate to count mild symptoms
count_mild_symptoms(SymptomsList, MildCount) :-
    include(mild_symptom, SymptomsList, MildSymptoms),
    length(MildSymptoms, MildCount).

% Define a predicate for severe symptoms
severe_symptom(Symptom) :-
    symptom(Symptom, severe).

% Define a predicate for moderate symptoms
moderate_symptom(Symptom) :-
    symptom(Symptom, moderate).

% Define a predicate for mild symptoms
mild_symptom(Symptom) :-
    symptom(Symptom, mild).

% Define a predicate to determine severity based on symptoms
determine_severity(SevereCount, ModerateCount, _, severe) :-
    SevereCount > 0,
    !.

determine_severity(_, ModerateCount, _, moderate) :-
    ModerateCount > 0,
    !.

determine_severity(_, _, MildCount, mild) :-
    MildCount > 0,
    !.

determine_severity(_, _, _, none).

% Define a predicate to determine recovery and hospitalization recommendations
recovery_and_hospitalization(Severity, Age, RiskFactorsList, Recommendation) :-
    (   Severity = severe,
        (   member(age_above_70, RiskFactorsList)
        ;   member(hypertension, RiskFactorsList)
        ;   member(cardiovascular_disease, RiskFactorsList)
        ),
        Age >= 60
    ->  Recommendation = 'Recommend hospitalization and immediate medical attention.'
    ;   Severity = moderate
    ->  Recommendation = 'Recommend medical advice and monitoring at home.'
    ;   Severity = mild
    ->  Recommendation = 'Recommend home isolation and monitoring.'
    ;   Recommendation = 'Recommend regular monitoring and follow medical guidance.'
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
diagnosis_message(_, _, mild, _, _, 'The patient may have a mild virus infection. Continue monitoring symptoms and follow medical guidance.').

% Define diagnosis message for moderate severity
diagnosis_message(_, _, moderate, _, _, 'The patient may have a moderate virus infection. Seek medical advice and follow medical guidance.').

% Default diagnosis message (if none of the above conditions match)
diagnosis_message(_, _, _, _, _, 'The patient is less likely to have the virus infection. Continue monitoring symptoms and follow medical guidance.').

% Define diagnosis message for the specific symptom combination
diagnosis_message(_, [fever, dry_cough, tiredness, shortness_of_breath, chest_pain], _, _, _, 'The patient is displaying multiple severe symptoms. Seek immediate medical attention and follow medical guidance.').

% Define diagnosis message for severe severity and relevant risk factors
diagnosis_message(_, _, severe, ContactHistory, _, 'The patient is at high risk of having a severe virus infection. Seek immediate medical attention and follow medical guidance.') :-
    (   member(age_above_70, ContactHistory)
    ;   member(hypertension, ContactHistory)
    ;   member(cardiovascular_disease, ContactHistory)
    ),
    !.

% Run the interactive diagnosis program
% :- start_diagnosis.


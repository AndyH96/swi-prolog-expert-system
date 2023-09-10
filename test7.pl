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

% Dynamic Facts for Patient Data
:- dynamic has_symptoms/2, has_risk_factors/2.

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

% Define a predicate to start the diagnosis
start_diagnosis :-
    writeln('Welcome to the Virus Infection Diagnosis System.'),
    writeln('Please enter the patient\'s name:'),
    read_line_to_string(user_input, PatientName),
    ask_patient_questions(PatientName).

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

ask_contact_history(PatientName) :-
    writeln('Has the patient had close contact with an infected person in the last 14 days (within the typical incubation period)? (yes/no)'),
    read_line_to_string(user_input, ContactHistory),
    ask_symptoms(PatientName, ContactHistory).

% Define a predicate to ask a series of questions to the patient
ask_patient_questions(PatientName) :-
    writeln('Do you want to provide new information about the patient\'s symptoms and risk factors? (yes/no)'),
    read_line_to_string(user_input, Response),
    (Response = 'yes' ->
        ask_symptoms(PatientName)
    ;   ask_contact_history(PatientName)
    ).

% Define a predicate to ask for symptoms and process the input
ask_symptoms(PatientName, ContactHistory) :-
    writeln('What are the patient\'s symptoms?'),
    display_symptom_options,
    read_line_to_string(user_input, SymptomsInput),
    process_symptoms(PatientName, ContactHistory, SymptomsInput).

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
    process_symptoms_list(PatientName, ContactHistory, SymptomsList).

% Define a predicate to process a list of symptoms
process_symptoms_list(_, _, []) :-  % No more symptoms to process
    !.

process_symptoms_list(PatientName, ContactHistory, [Symptom | Rest]) :-
    trim_spaces(Symptom, TrimmedSymptom),  % Remove leading/trailing spaces
    (symptom(TrimmedSymptom, _) ->
        assertz(has_symptoms(PatientName, [TrimmedSymptom | Rest])),
        process_symptoms_list(PatientName, ContactHistory, Rest)
    ;   writeln('Invalid symptom detected. Please enter valid symptoms.'),  % Invalid symptom, show a message
        ask_symptoms(PatientName, ContactHistory)
    ).

% Define a predicate to trim spaces from the beginning of a string
trim_spaces(String, Trimmed) :-
    atom_codes(String, Codes),
    trim_spaces_codes(Codes, TrimmedCodes),
    atom_codes(Trimmed, TrimmedCodes).

% Define a predicate to trim spaces from the beginning of a list
trim_spaces_codes([], []).

trim_spaces_codes([32 | Rest], Trimmed) :-  % 32 is the ASCII code for space
    trim_spaces_codes(Rest, Trimmed).

trim_spaces_codes(Trimmed, Trimmed).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Diagnosis Classification %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Define a predicate to classify severity based on symptoms
classify_severity(PatientName, Severity) :-
    has_symptoms(PatientName, Symptoms),
    classify_symptom_severity(Symptoms, Severity).

% Define a predicate to classify the severity of symptoms
classify_symptom_severity(Symptoms, Severity) :-
    member(Symptom, Symptoms),
    symptom(Symptom, Severity).

% Define a predicate to determine severity based on symptoms and risk factors
determine_severity(PatientName, Severity) :-
    classify_severity(PatientName, SymptomSeverity),
    has_risk_factors(PatientName, RiskFactors),
    recommend_diagnosis(SymptomSeverity, RiskFactors).

% Define a predicate to recommend actions based on severity and risk factors
recommend_diagnosis(severe, RiskFactors) :-
    (member(age_above_70, RiskFactors) ; member(hypertension, RiskFactors) ;
    member(diabetes, RiskFactors) ; member(cardiovascular_disease, RiskFactors) ;
    member(chronic_respiratory_disease, RiskFactors) ; member(cancer, RiskFactors)),
    writeln('Recommendation: Seek immediate medical attention! Contact your doctor or health facility.'),
    writeln('Action: Proceed with an initial assessment call to the doctor or health facility.'),
    !.

recommend_diagnosis(severe, _) :-
    writeln('Recommendation: Seek immediate medical attention! Contact your doctor or health facility.'),
    writeln('Action: Proceed with an initial assessment call to the doctor or health facility.'),
    !.

recommend_diagnosis(moderate, _) :-
    writeln('Recommendation: Monitor your symptoms closely at home.'),
    writeln('Action: If symptoms worsen, contact your healthcare provider.'),
    !.

recommend_diagnosis(mild, _) :-
    writeln('Recommendation: Manage your symptoms at home.'),
    writeln('Action: Get plenty of rest, stay hydrated, and monitor your condition.'),
    !.

recommend_diagnosis(none, _) :-
    writeln('Recommendation: You are asymptomatic.'),
    writeln('Action: Continue to practice good hygiene and social distancing to prevent the spread of the virus.'),
    !.
agnosis program
% :- start_diagnosis.
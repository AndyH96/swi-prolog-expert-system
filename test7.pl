%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Defining Knowledge Base %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

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

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Interactive Patient Diagnosis %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% This portion of the code is dedicated to asking a series of questions to evaluate the patients risk/diagnosis.

% Define a predicate to start the diagnosis
start_diagnosis :-
    writeln('Welcome to the Virus Infection Diagnosis System.'),
    writeln('Please enter the patient\'s name:'),
    read_line_to_string(user_input, PatientName),
    ask_age(Age).

% Define a predicate to ask patient age
ask_age(Age) :-
    writeln('Please enter the patient\'s age:'),
    read_integer(Age),
    ask_gender(Gender).

% Define a predicate to ask patient gender
ask_gender(Gender) :-
    writeln('Please enter the patient\'s gender (male/female):'),
    read_line_to_string(user_input, Gender),
    ask_contact_history(ContactHistory).

% Define a predicate to ask about patient recent contact history
ask_contact_history(ContactHistory) :-
    writeln('Has the patient had close contact with an infected person in the last 14 days (incubation period)? (yes/no)'),
    read_line_to_string(user_input, ContactHistory),
    (ContactHistory = 'yes' -> 
        writeln('Recommendation: Isolate at home and monitor your symptoms closely.'),
        writeln('Action: If symptoms worsen, contact your healthcare provider immediately.'); 
     ContactHistory = 'no' -> 
        ask_symptoms(AvailableSymptoms)
    ).

% Define a predicate to ask for symptoms and process the input
ask_symptoms(AvailableSymptoms) :-
    writeln('What are the patient\'s symptoms?'),
    writeln('Select all that apply, separated by commas, and with no spaces (e.g: fever,dry_cough):'),
    display_symptom_options, 
    read_line_to_string(user_input, SymptomsInput),
    process_symptoms(SymptomsInput).

% Display the list of symptom options to the user
display_symptom_options :-
    writeln('- fever'),
    writeln('- dry_cough'),
    writeln('- tiredness'),
    writeln('- aches_and_pains'),
    writeln('- sore_throat'),
    writeln('- diarrhea'),
    writeln('- conjunctivitis'),
    writeln('- headache'),
    writeln('- anosmia'),
    writeln('- shortness_of_breath'),
    writeln('- chest_pain'),
    writeln('- loss_of_speech_or_movement'),
    writeln('- asymptomatic').

% Define a predicate to process the input for symptoms
process_symptoms(SymptomsInput) :-
    atom_string(SymptomsAtom, SymptomsInput),
    atomic_list_concat(SymptomsList, ',', SymptomsAtom),
    process_symptoms_list(SymptomsList),
    ask_risk_factors(RiskFactors).

% Define a predicate to ask for risk factors and process the input
ask_risk_factors(RiskFactors) :-
    writeln('What are the patient\'s risk factors:'),
    writeln('Select all that apply, separated by commas, and with no spaces (e.g., age_above_70,hypertension):'),
    display_risk_factors, 
    read_line_to_string(user_input, RiskFactorsInput),
    process_risk_factors_input(RiskFactorsInput).

% Display the list of risk factor options to the user
display_risk_factors :-
    writeln('1. age_above_70'),
    writeln('2. hypertension'),
    writeln('3. diabetes'),
    writeln('4. cardiovascular disease'),
    writeln('5. chronic respiratory disease'),
    writeln('6. cancer'),
    writeln('7. male').

% Define a predicate to process the input of patient risk factors
process_risk_factors(RiskFactorsInput) :-
    process_risk_factors_list(RiskFactorsList).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Diagnosis Calculation %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Define rules for assigning points to symptoms
symptom_points(fever, mild, 1).
symptom_points(dry_cough, mild, 1).
symptom_points(tiredness, mild, 1).
symptom_points(aches_and_pains, mild, 1).
symptom_points(sore_throat, mild, 1).
symptom_points(diarrhea, mild, 1).
symptom_points(conjunctivitis, mild, 1).
symptom_points(headache, moderate, 2).
symptom_points(anosmia, moderate, 2).
symptom_points(shortness_of_breath, severe, 3).
symptom_points(chest_pain, severe, 3).
symptom_points(loss_of_speech_or_movement, severe, 3).
symptom_points(asymptomatic, none, 0).

% Define rules for assigning points to risk factors
risk_factor_points(age_above_70, 2).
risk_factor_points(hypertension, 1).
risk_factor_points(diabetes, 1).
risk_factor_points(cardiovascular_disease, 2).
risk_factor_points(chronic_respiratory_disease, 1).
risk_factor_points(cancer, 1).
risk_factor_points(male, 1).

% Extra 0.5 points if they had close contact with an infected person
close_contact_points(yes, 0.5).
close_contact_points(no, 0).

% Calculate total points for symptoms
calculate_symptom_points(PatientName, SymptomPoints) :-
    findall(Points, (has_symptoms(PatientName, Symptoms), member(Symptom, Symptoms), symptom_points(Symptom, _, Points)), SymptomPointsList),
    sum_list(SymptomPointsList, SymptomPoints).

% Calculate total points for risk factors
calculate_risk_factor_points(PatientName, RiskFactorPoints) :-
    has_risk_factors(PatientName, RiskFactors),
    findall(Points, (member(RiskFactor, RiskFactors), risk_factor_points(RiskFactor, Points)), RiskFactorPointsList),
    sum_list(RiskFactorPointsList, RiskFactorPoints).

% Calculate total points for close contact history
calculate_close_contact_points(ContactHistory, CloseContactPoints) :-
    close_contact_points(ContactHistory, CloseContactPoints).

% Calculate total points for symptoms, risk factors, and close contact
calculate_points(PatientName, Age, Gender, ContactHistory, TotalPoints) :-
    calculate_symptom_points(PatientName, SymptomPoints),
    calculate_risk_factor_points(PatientName, RiskFactorPoints),
    calculate_close_contact_points(ContactHistory, CloseContactPoints),
    TotalPoints is SymptomPoints + RiskFactorPoints + CloseContactPoints.


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Diagnosis Classification %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Define a predicate to recommend diagnosis and actions based on total points
recommend_diagnosis(TotalPoints, RiskFactors) :-
    (TotalPoints >= 3 ->
        writeln('Diagnosis: Severe'),
        writeln('Recommendation: Seek immediate medical attention! Contact your doctor or health facility.'),
        writeln('Action: Proceed with an initial assessment call to the doctor or health facility.')

    ; TotalPoints = 2 ->
        writeln('Diagnosis: Moderate'),
        writeln('Recommendation: Monitor your symptoms closely at home.'),
        writeln('Action: If symptoms worsen, contact your healthcare provider.')

    ; TotalPoints = 1 ->
        writeln('Diagnosis: Mild'),
        writeln('Recommendation: Manage your symptoms at home.'),
        writeln('Action: Get plenty of rest, stay hydrated, and monitor your condition.')

    ; TotalPoints = 0 ->
        writeln('Diagnosis: None'),
        writeln('Recommendation: You are asymptomatic.'),
        writeln('Action: Continue to practice good hygiene and social distancing to prevent the spread of the virus.')

    ),
    % You can add additional recommendations or actions based on specific risk factors here.
    % For example, if a patient has a certain risk factor, you can provide tailored advice.
    % Remember to handle other cases or provide fallback recommendations as needed.
    !.

calculate_points(PatientName, Age, Gender, ContactHistory, TotalPoints),
recommend_diagnosis(TotalPoints, RiskFactors).

% :- start_diagnosis.
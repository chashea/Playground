def ask_questions():
    questions = [
        {
            "question": "What is the correct file extension for Python files?",
            "choices": ["A. .py", "B. .python", "C. .pt", "D. .pyt"],
            "answer": "A",
            "explanation": "The correct file extension for Python files is .py. The other options are not valid Python file extensions."
        },
        {
            "question": "How do you create a variable with the numeric value 5?",
            "choices": ["A. x = 5", "B. x == 5", "C. x : 5", "D. x <- 5"],
            "answer": "A",
            "explanation": "In Python, you create a variable by using the equals sign (=). The other options are not valid syntax for variable assignment in Python."
        },
        {
            "question": "Which of the following is a valid Python function definition?",
            "choices": ["A. function myFunction()", "B. def myFunction():", "C. func myFunction():", "D. define myFunction()"],
            "answer": "B",
            "explanation": "In Python, functions are defined using the 'def' keyword followed by the function name and parentheses. The other options use incorrect keywords."
        },
        {
            "question": "How do you insert comments in Python code?",
            "choices": ["A. // This is a comment", "B. <!-- This is a comment -->", "C. # This is a comment", "D. /* This is a comment */"],
            "answer": "C",
            "explanation": "In Python, comments are inserted using the hash symbol (#). The other options are comment syntax for other programming languages."
        },
        {
            "question": "Which method can be used to remove any whitespace from both the beginning and the end of a string?",
            "choices": ["A. strip()", "B. trim()", "C. ptrim()", "D. len()"],
            "answer": "A",
            "explanation": "The strip() method removes whitespace from both the beginning and the end of a string. The other options are not valid methods for this purpose in Python."
        },
        {
            "question": "Which of the following is used to define a block of code in Python?",
            "choices": ["A. Curly braces {}", "B. Parentheses ()", "C. Indentation", "D. Square brackets []"],
            "answer": "C",
            "explanation": "In Python, indentation is used to define a block of code. The other options are not used for this purpose in Python."
        },
        {
            "question": "How do you start a for loop in Python?",
            "choices": ["A. for x in y:", "B. for (x in y)", "C. foreach x in y:", "D. for each x in y:"],
            "answer": "A",
            "explanation": "In Python, a for loop is started with 'for x in y:'. The other options use incorrect syntax."
        },
        {
            "question": "Which of the following is the correct way to create a list in Python?",
            "choices": ["A. myList = {}", "B. myList = []", "C. myList = ()", "D. myList = <>"],
            "answer": "B",
            "explanation": "In Python, lists are created using square brackets []. The other options use incorrect syntax for creating a list."
        },
        {
            "question": "How do you check if a value is present in a list in Python?",
            "choices": ["A. if x in myList", "B. if x exists myList", "C. if x present myList", "D. if x has myList"],
            "answer": "A",
            "explanation": "In Python, you check if a value is present in a list using 'if x in myList'. The other options use incorrect syntax."
        },
        {
            "question": "Which of the following is used to handle exceptions in Python?",
            "choices": ["A. try/except", "B. catch/except", "C. try/catch", "D. handle/except"],
            "answer": "A",
            "explanation": "In Python, exceptions are handled using 'try/except'. The other options use incorrect keywords."
        },
        {
            "question": "What is the output of print(2 ** 3)?",
            "choices": ["A. 6", "B. 8", "C. 9", "D. 12"],
            "answer": "B",
            "explanation": "The '**' operator is used for exponentiation in Python. 2 ** 3 equals 8."
        },
        {
            "question": "Which of the following is a mutable data type in Python?",
            "choices": ["A. tuple", "B. list", "C. string", "D. int"],
            "answer": "B",
            "explanation": "Lists are mutable, meaning their elements can be changed. Tuples, strings, and integers are immutable."
        },
        {
            "question": "How do you start a while loop in Python?",
            "choices": ["A. while x > y:", "B. while (x > y)", "C. while x > y do", "D. while (x > y):"],
            "answer": "A",
            "explanation": "In Python, a while loop is started with 'while x > y:'. The other options use incorrect syntax."
        },
        {
            "question": "Which of the following is the correct way to create a dictionary in Python?",
            "choices": ["A. myDict = {}", "B. myDict = []", "C. myDict = ()", "D. myDict = <>"],
            "answer": "A",
            "explanation": "In Python, dictionaries are created using curly braces {}. The other options use incorrect syntax for creating a dictionary."
        },
        {
            "question": "How do you access the value associated with a key in a dictionary?",
            "choices": ["A. myDict[key]", "B. myDict.key", "C. myDict->key", "D. myDict[key()]"],
            "answer": "A",
            "explanation": "In Python, you access the value associated with a key in a dictionary using square brackets []. The other options use incorrect syntax."
        },
        {
            "question": "Which of the following is used to define a class in Python?",
            "choices": ["A. class MyClass:", "B. define MyClass:", "C. class MyClass()", "D. def MyClass:"],
            "answer": "A",
            "explanation": "In Python, classes are defined using the 'class' keyword followed by the class name and a colon. The other options use incorrect syntax."
        },
        {
            "question": "How do you create an instance of a class in Python?",
            "choices": ["A. myObject = MyClass()", "B. myObject = MyClass", "C. myObject = new MyClass()", "D. myObject = create MyClass()"],
            "answer": "A",
            "explanation": "In Python, you create an instance of a class by calling the class name followed by parentheses. The other options use incorrect syntax."
        },
        {
            "question": "Which of the following is used to import a module in Python?",
            "choices": ["A. import module", "B. include module", "C. using module", "D. require module"],
            "answer": "A",
            "explanation": "In Python, modules are imported using the 'import' keyword. The other options use incorrect keywords."
        },
        {
            "question": "How do you define a constructor in a Python class?",
            "choices": ["A. def __init__(self):", "B. def constructor(self):", "C. def __construct__(self):", "D. def init(self):"],
            "answer": "A",
            "explanation": "In Python, constructors are defined using the '__init__' method. The other options use incorrect method names."
        },
        {
            "question": "Which of the following is used to read a file in Python?",
            "choices": ["A. open('file.txt', 'r')", "B. read('file.txt')", "C. file('file.txt', 'r')", "D. get('file.txt')"],
            "answer": "A",
            "explanation": "In Python, files are read using the 'open' function with the 'r' mode. The other options use incorrect functions or modes."
        }
    ]

    score = 0

    for i, q in enumerate(questions):
        print(f"Q{i+1}: {q['question']}")
        for choice in q['choices']:
            print(choice)
        while True:
            answer = input("Your answer: ").strip().upper()
            if answer == q['answer']:
                score += 1
                print(f"Correct! {q['explanation']}\n")
                break
            else:
                print("Wrong! Try again.\n")

    print(f"Your final score is {score} out of {len(questions)}")

if __name__ == "__main__":
    ask_questions()
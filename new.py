# Domain: Data Science and Machine Learning pipeline automation.
# Purpose: Simplify ML workflow using a DSL → auto-generate Python.
# Phases Implemented:
# -Lexer → tokenizes DSL.
# -Parser → builds AST.
# -Semantic Analyzer → checks correctness.
# -Code Generator → produces Python code.
# Input: DSL describing pipelines.
# Output: Python script with pandas, scikit-learn pipelines.
import pprint

# --- Lexer Section ---
KEYWORDS = [
    'PIPELINE', 'DATA', 'FROM', 'CLEAN', 'REMOVE_NULLS', 'HANDLE_OUTLIERS',
    'FEATURE_ENGINEER', 'CREATE', 'MODEL', 'KMEANS', 'CLASSIFIER', 'EXPORT', 'as',
    'VISUALIZE', 'PLOT', 'INTO', 'ENCODE', 'NORMALIZE', 'RANDOM_FOREST', 'TARGET'
]
TOKEN_TYPES = ('KEYWORD', 'IDENTIFIER', 'STRING', 'NUMBER', 'PUNCTUATION', 'COMMENT')

class Token:
    def __init__(self, type_, value, line=0):
        self.type = type_
        self.value = value
        self.line = line
    def __repr__(self):
        return f"{self.type}:{self.value} (Line {self.line})"

class Lexer:
    def __init__(self, source):
        self.lines = source.split('\n')
        self.tokens = []

    def tokenize(self):
        print("=== LEXICAL ANALYSIS START ===")
        for line_number, line in enumerate(self.lines, 1):
            i = 0
            while i < len(line):
                if line[i].isspace():
                    i += 1
                elif line[i] == '/' and i + 1 < len(line) and line[i+1] == '/':
                    comment = line[i:]
                    self.tokens.append(Token('COMMENT', comment, line_number))
                    print(f"Comment detected at line {line_number}: {comment}")
                    break
                elif line[i] == '"':
                    j = i + 1
                    while j < len(line) and line[j] != '"':
                        j += 1
                    string_val = line[i+1:j]
                    self.tokens.append(Token('STRING', string_val, line_number))
                    print(f"String literal at line {line_number}: \"{string_val}\"")
                    i = j + 1
                elif line[i].isdigit():
                    j = i
                    while j < len(line) and (line[j].isdigit() or line[j] == '.'):
                        j += 1
                    num_val = line[i:j]
                    self.tokens.append(Token('NUMBER', num_val, line_number))
                    print(f"Number literal at line {line_number}: {num_val}")
                    i = j
                elif line[i].isalpha() or line[i] == '_':
                    j = i
                    while j < len(line) and (line[j].isalnum() or line[j] == "_"):
                        j += 1
                    word = line[i:j]
                    typ = "KEYWORD" if word in KEYWORDS else "IDENTIFIER"
                    self.tokens.append(Token(typ, word, line_number))
                    print(f"Token '{word}' of type {typ} at line {line_number}")
                    i = j
                elif line[i] in '{}()[],.=+-*/<>':
                    self.tokens.append(Token('PUNCTUATION', line[i], line_number))
                    print(f"Punctuation '{line[i]}' at line {line_number}")
                    i += 1
                else:
                    print(f"Ignored character '{line[i]}' at line {line_number}")
                    i += 1
        print(f"=== Total Tokens: {len(self.tokens)} ===")
        print("=== LEXICAL ANALYSIS END ===\n")
        return self.tokens

# --- AST Definitions ---
class Pipeline: 
    def __init__(self, name): 
        self.name = name 
        self.stages = []

class DataLoad: 
    def __init__(self, var, src): 
        self.var = var 
        self.src = src

class Clean: 
    def __init__(self, var, ops): 
        self.var = var 
        self.ops = ops

class Model: 
    def __init__(self, var, mtype, params=None): 
        self.var = var 
        self.mtype = mtype
        self.params = params or {}

class Export: 
    def __init__(self, what): 
        self.what = what

# --- Parser Section ---
class Parser:
    def __init__(self, tokens):
        self.tokens = tokens
        self.pos = 0
        self.errors = []

    def current(self):
        return self.tokens[self.pos] if self.pos < len(self.tokens) else None

    def expect(self, value):
        token = self.current()
        if not token or token.value != value:
            error_msg = f"Expected '{value}', got '{token.value if token else None}' at token position {self.pos}"
            self.errors.append(error_msg)
            raise Exception(error_msg)
        self.pos += 1

    def parse(self):
        print("=== SYNTAX ANALYSIS START ===")
        pipelines = []
        while self.current():
            try:
                if self.current().value == 'PIPELINE':
                    pipeline = self.parse_pipeline()
                    pipelines.append(pipeline)
                    print(f"Parsed Pipeline: {pipeline.name} with {len(pipeline.stages)} stage(s)")
                else:
                    print(f"Skipping unexpected token {self.current().value} at pos {self.pos}")
                    self.pos += 1
            except Exception as e:
                print("Parsing Error:", e)
                break
        print(f"=== Total Pipelines Parsed: {len(pipelines)} ===")
        print("=== SYNTAX ANALYSIS END ===\n")
        return pipelines

    def parse_pipeline(self):
        self.expect('PIPELINE')
        name = self.current().value
        print(f"Parsing pipeline named '{name}'")
        self.pos += 1
        self.expect('{')
        pipeline = Pipeline(name)
        while self.current() and self.current().value != '}':
            val = self.current().value
            if val == 'DATA':
                pipeline.stages.append(self.parse_data())
            elif val == 'CLEAN':
                pipeline.stages.append(self.parse_clean())
            elif val == 'MODEL':
                pipeline.stages.append(self.parse_model())
            elif val == 'EXPORT':
                pipeline.stages.append(self.parse_export())
            else:
                print(f"Skipping unknown stage token '{val}' at pos {self.pos}")
                self.pos += 1
        self.expect('}')
        return pipeline

    def parse_data(self):
        self.expect('DATA')
        var = self.current().value
        print(f"Parsing DATA stage with var '{var}'")
        self.pos += 1
        self.expect('FROM')
        src = self.current().value
        self.pos += 1
        print(f"Source data set as '{src}'")
        return DataLoad(var, src)

    def parse_clean(self):
        self.expect('CLEAN')
        var = self.current().value
        self.pos += 1
        self.expect('{')
        ops = []
        while self.current() and self.current().value != '}':
            ops.append(self.current().value)
            print(f"Cleaning operation: {ops[-1]}")
            self.pos += 1
        self.expect('}')
        return Clean(var, ops)

    def parse_model(self):
        self.expect('MODEL')
        var = self.current().value
        self.pos += 1
        self.expect('=')
        mtype = self.current().value
        print(f"Parsing MODEL '{var}' of type '{mtype}'")
        self.pos += 1
        params = {}
        return Model(var, mtype, params)

    def parse_export(self):
        self.expect('EXPORT')
        self.expect('{')
        what = []
        while self.current() and self.current().value != '}':
            what.append(self.current().value)
            print(f"Export target: {what[-1]}")
            self.pos += 1
        self.expect('}')
        return Export(what)

# --- Semantic Analyzer Section ---
class SemanticAnalyzer:
    def __init__(self, pipeline_ast):
        self.ast = pipeline_ast
        self.errors = []
        self.symbol_table = set()

    def analyze(self):
        print("=== SEMANTIC ANALYSIS START ===")
        for pipeline in self.ast:
            print(f"Analyzing pipeline '{pipeline.name}'")
            for stage in pipeline.stages:
                self.check_stage(stage)

        if self.errors:
            print("Semantic Errors Found:")
            for err in self.errors:
                print(" -", err)
        else:
            print("No semantic errors detected.")

        print("\n--- SYMBOL TABLE ---")
        print(self.symbol_table)  

        print("=== SEMANTIC ANALYSIS END ===\n")
        return not self.errors

    def check_stage(self, stage):
        if isinstance(stage, DataLoad):
            print(f"Registering dataset variable '{stage.var}'")
            if stage.var in self.symbol_table:
                self.errors.append(f"Duplicate variable '{stage.var}'")
            self.symbol_table.add(stage.var)
        elif isinstance(stage, Clean):
            if stage.var not in self.symbol_table:
                self.errors.append(f"Clean operation on undefined variable '{stage.var}'")
            else:
                print(f"Valid clean operations for variable '{stage.var}': {', '.join(stage.ops)}")
        elif isinstance(stage, Model):
            print(f"Model '{stage.var}' of type '{stage.mtype}' will be created")
            if stage.var in self.symbol_table:
                self.errors.append(f"Duplicate variable/model '{stage.var}'")
            self.symbol_table.add(stage.var)
        elif isinstance(stage, Export):
            for obj in stage.what:
                if obj not in self.symbol_table:
                    self.errors.append(f"Exporting undefined object '{obj}'")
                else:
                    print(f"Exporting object '{obj}'")

# --- Code Generator Section ---
class CodeGen:
    def __init__(self, pipelines):
        self.pipelines = pipelines

    def generate(self):
        print("=== CODE GENERATION START ===")
        code = ["# ----- AUTO-GENERATED DATA SCIENCE PIPELINE -----"]
        code += ['import pandas as pd', 'import numpy as np']
        code += ['from sklearn.cluster import KMeans']
        code += ['from sklearn.ensemble import RandomForestClassifier']
        code += ['# Additional imports can be added here\n']

        for p in self.pipelines:
            code.append(f'def {p.name.lower()}():')
            for s in p.stages:
                gen_lines = self.generate_stage(s)
                code.extend(gen_lines)
                print(f"Generated {len(gen_lines)} lines for stage {type(s).__name__}")
            code.append("")

        code.append('\nif __name__ == "__main__":')
        for p in self.pipelines:
            code.append(f'    {p.name.lower()}()')

        print(f"=== Total lines of code generated: {len(code)} ===")
        print("=== CODE GENERATION END ===\n")
        return '\n'.join(code)

    def generate_stage(self, s):
        lines = []
        if isinstance(s, DataLoad):
            lines += [
                f'    # Load dataset',
                f'    {s.var} = pd.read_csv({s.src})',
                f'    print("Loaded", len({s.var}), "rows from {s.src}")'
            ]
        elif isinstance(s, Clean):
            clean_ops = ', '.join(s.ops)
            lines += [
                f'    # Data Cleaning: {clean_ops}',
                f'    {s.var} = {s.var}.dropna()  # Currently only dropna implemented',
                f'    print("After cleaning, {len(" + s.var + ")} records remain")'
            ]
        elif isinstance(s, Model):
            if s.mtype == "KMEANS":
                lines += [
                    f'    # Clustering with KMeans',
                    f'    model = KMeans(n_clusters=4)',
                    f'    labels = model.fit_predict({s.var})',
                    f'    print("KMeans labels:", labels)'
                ]
            elif s.mtype == "RANDOM_FOREST":
                lines += [
                    f'    # Classification with Random Forest (requires feature/target setup)',
                    f'    model = RandomForestClassifier(n_estimators=100)',
                    f'    # X, y = ...  # Define features and target here',
                    f'    # model.fit(X, y)',
                    f'    print("RandomForest model created")'
                ]
            else:
                lines += [f'    # Unsupported model type: {s.mtype}']
        elif isinstance(s, Export):
            objs = ', '.join(s.what)
            lines += [
                f'    # Exporting objects: {objs}',
                f'    # Add export code here',
                f'    print("Exported: {objs}")'
            ]
        return lines

# --- Example main usage ---
def main():
    dsl_code = '''
// Sample pipeline in DSL
PIPELINE CustomerSegmentation {
    DATA customers FROM "customers.csv"
    CLEAN customers { REMOVE_NULLS }
    MODEL cluster_model = KMEANS
    EXPORT { cluster_model }
}

PIPELINE LoanRiskClassification {
    DATA loans FROM "loans.csv"
    CLEAN loans { REMOVE_NULLS }
    MODEL risk_model = RANDOM_FOREST
    EXPORT { risk_model }
}
'''
    print("\n--- INPUT DSL CODE ---\n", dsl_code)

    lexer = Lexer(dsl_code)
    tokens = lexer.tokenize()
    print("\n--- TOKENS ---\n")
    pprint.pprint(tokens)

    parser = Parser(tokens)
    try:
        pipelines = parser.parse()
    except Exception as parse_error:
        print("\nParsing failed:", parse_error)
        return

    print("\n--- AST STRUCTURE ---\n")
    for p in pipelines:
        print(f"Pipeline: {p.name}")
        for s in p.stages:
            print(f"  Stage: {type(s).__name__} - {vars(s)}")

    semantic = SemanticAnalyzer(pipelines)
    ok = semantic.analyze()
    if not ok:
        print("\nCompilation aborted due to semantic errors.")
        return

    codegen = CodeGen(pipelines)
    code_output = codegen.generate()
    print("\n--- GENERATED PYTHON CODE ---\n")
    print(code_output)

if __name__ == "__main__":
    main()

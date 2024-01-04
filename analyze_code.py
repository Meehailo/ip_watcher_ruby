import openai
import os

openai.api_key = os.getenv("OPENAI_API_KEY")

def analyze_code_with_chatgpt(code_snippet):
    try:
        response = openai.Completion.create(
          model="text-davinci-003",
          prompt=f"Review the following code and provide suggestions for improvement:\n\n{code_snippet}",
          temperature=0.7,
          max_tokens=150
        )
        return response.choices[0].text.strip()
    except Exception as e:
        print(f"An error occurred: {e}")
        return None

code_snippet = """
def example_function():
    print("This is an example function.")
"""

result = analyze_code_with_chatgpt(code_snippet)
print("Suggestions from ChatGPT:\n", result)

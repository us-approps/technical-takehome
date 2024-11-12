

"""
Question 2a

Write a Python function that accepts a string as input and replaces
all occurrences of names with the string "ANON.”
In the function’s docstring, list at least three test strings and the expected output.
Assume names are capitalized words and may be separated by spaces or by punctuation.
No other words are capitalized.

"""


def anonymize_names(text):
    """
    Replaces all occurrences of names (capitalized words) in the given text with 'ANON.'

    Args: text (str): Input string containing names and other text.

    Returns:
    str: Text with names replaced by 'ANON.'

    Note: this question can also be solved with regular expression
            return re.sub(r'\b[A-Z][a-z]*\b', 'ANON', text)

    """
    words = text.split()
    anonymized_words = []

    for word in words:
        # Remove trailing punctuation for the capitalization check
        stripped_word = word.rstrip(",.!?;:")

        if stripped_word.istitle():  # Check if the word is capitalized
            anonymized_words.append("ANON" + word[len(stripped_word):])  # Preserve punctuation
        else:
            anonymized_words.append(word)

    return ' '.join(anonymized_words)

 
if __name__ == '__main__':
    # Example usage
    # Example strings- you can add more test strings. No expectation that these all
    # pass!
    partb_test_strings = [
        "Alice and Bob are talking to Charlie about going to New York City.",
        "alice and bob are discussing with Charlie about visiting Los Angeles.",
        "Bob and Eve are planning a trip to paris next summer.",
        "Charlie and Alice met with Dave in San Francisco last week.",
        "eve and Charlie were excited about the event in Chicago.",
        "Charlie and Bob are thinking of moving to Tokyo soon.",
        "Alice and Dave went to see a show in London.",
        "Alice and Bob had dinner with Eve in Madrid.",
        "bob and Eve are going to Sydney for a conference.",
        "Charlie and Alice took a vacation in Rome.",
        "Charlie and Dave are considering a job offer in Berlin.",
        "eve and Charlie are visiting their friend in Amsterdam.",
        "Charlie and Bob are attending a wedding in Bangkok.",
        "Alice and Dave spent their holidays in Barcelona.",
        "Bob and Eve are looking for apartments in Vienna.",
        "Charlie and Dave are organizing an event in Prague.",
        "alice and Charlie are exploring opportunities in Dubai.",
        "Bob and Charlie are discussing their plans in Dublin.",
        "Alice and Bob are thinking about a trip to Vancouver.",
        "Charlie and Eve are preparing for a move to Montreal."
    ]
    for input_text in partb_test_strings:
        print(f"{input_text} -> {anonymize_names(input_text)}")
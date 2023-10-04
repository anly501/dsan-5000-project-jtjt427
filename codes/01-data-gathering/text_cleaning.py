import requests
import json
import re
import pandas as pd
from sklearn.feature_extraction.text import CountVectorizer

# Load the JSON data from the file
with open("raw-data/articles.json", "r") as json_file:
    data = json.load(json_file)
    articles = pd.DataFrame(data)

verbose=True

def string_cleaner(input_string):
    out = ''
    try: 
        out=re.sub(r"""
                    [,.;@#?!&$-]+  # Accept one or more copies of punctuation
                    \ *           # plus zero or more copies of a space,
                    """,
                    " ",          # and replace it with a single space
                    input_string, flags=re.VERBOSE)

        #REPLACE SELECT CHARACTERS WITH NOTHING
        out = re.sub('[’.]+', '', input_string)

        #ELIMINATE DUPLICATE WHITESPACES USING WILDCARDS
        out = re.sub(r'\s+', ' ', out)

        #CONVERT TO LOWER CASE
        out=out.lower()
    except:
        print("ERROR")
        out=''
    return out
    
article_keys = articles.columns
print("AVAILABLE KEYS:")
print(article_keys)

index = 0
cleaned_data = []

for _, article in articles.iterrows():
    tmp = []
    if verbose:
        print("#------------------------------------------")
        print("#", index)
        print("#------------------------------------------")

    for key in article_keys:
        if verbose:
            print("----------------")
            print(key)
            print(article[key])  # Access the value directly

        if key == 'source':
            src = string_cleaner(article['source']['name'])
            tmp.append(src)

        if key == 'author':
            author = string_cleaner(article['author'])
            # ERROR CHECK (SOMETIMES AUTHOR IS SAME AS PUBLICATION)
            if src in author:
                print(" AUTHOR ERROR:", author)
                author = 'NA'
            tmp.append(author)

        if key == 'title':
            tmp.append(string_cleaner(article['title']))

        if key == 'description':
            tmp.append(string_cleaner(article['description']))

        if key == 'content':
            tmp.append(string_cleaner(article['content']))

        if key == 'publishedAt':
            # DEFINE DATA PATTERN FOR RE TO CHECK  .* --> wildcard
            ref = re.compile('.*-.*-.*T.*:.*:.*Z')
            date = article['publishedAt']
            if not ref.match(date):
                print(" DATE ERROR:", date)
                date = "NA"
            tmp.append(date)

    cleaned_data.append(tmp)
    index += 1


def apply_count_vectorizer(text_data):
    # Create an instance of CountVectorizer
    vectorizer = CountVectorizer()
    
    # Fit and transform the text data
    X = vectorizer.fit_transform(text_data)
    
    # Get the feature names (tokens)
    feature_names = vectorizer.get_feature_names_out()
    
    # Convert the matrix to a DataFrame for better readability
    count_matrix = pd.DataFrame(X.toarray(), columns=feature_names)
    
    return count_matrix
# Apply CountVectorizer to article contents
description_data = [article[4] for article in cleaned_data] 
description_count_matrix = apply_count_vectorizer(description_data)
print(description_count_matrix)

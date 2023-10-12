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

# Define a filter condition to check for "[removed]" in column 5
filter_condition = lambda article: article[5] != "[removed]"

# Use a list comprehension to create a new cleaned_data list with rows that satisfy the condition
cleaned_data_filtered = [article for article in cleaned_data if filter_condition(article)]

df = pd.DataFrame(cleaned_data_filtered)

# Save the DataFrame to a CSV file
df.to_csv("../data/cleaned-data/cleaned_text_data.csv", index=False)

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
content_data = [article[5] for article in cleaned_data_filtered] 
content_count_matrix = apply_count_vectorizer(content_data)
print(content_count_matrix)

from nltk.sentiment import SentimentIntensityAnalyzer 

# Initialize the SentimentIntensityAnalyzer
sia = SentimentIntensityAnalyzer()

# Analyze the sentiment of each article's content and store the sentiment scores
sentiments = []

for content in content_data:
    sentiment_score = sia.polarity_scores(content)
    sentiments.append(sentiment_score)

# Create a DataFrame for the sentiment scores
sentiments_df = pd.DataFrame(sentiments)

cleaned_text_data = pd.read_csv("../data/cleaned-data/cleaned_text_data.csv")
# Combine the sentiment scores with the original article DataFrame
articles_with_sentiment = pd.concat([cleaned_text_data, sentiments_df], axis=1)

# Rename columns
articles_with_sentiment = articles_with_sentiment.rename(columns={
    '...1': 'index',
    '0': 'source',
    '1': 'author',
    '2': 'title',
    '3': 'description',
    '4': 'date',
    '5': 'content'
})

# Print the DataFrame to verify the changes
print(articles_with_sentiment)

articles_with_sentiment.to_csv("../data/cleaned-data/articles_with_sentiment.csv")

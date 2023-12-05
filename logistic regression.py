import pandas as pd
import numpy as np
save_path = '/Users/oliviamurray/Documents/PhD/MISTIE/logistic.xlsx'
from sklearn.preprocessing import StandardScaler
from sklearn.model_selection import train_test_split
from sklearn.linear_model import LogisticRegression, LogisticRegressionCV
from sklearn.metrics import log_loss, roc_auc_score, recall_score, precision_score, average_precision_score, f1_score, classification_report, accuracy_score, plot_roc_curve, plot_precision_recall_curve, plot_confusion_matrix
df = pd.read_excel('/Users/oliviamurray/Documents/PhD/MISTIE/logistic.xlsx', na_values='?')
# following https://www.justintodata.com/logistic-regression-example-in-python/
#df = pd.get_dummies(df, columns=[ 'Involvement'], drop_first=True)
df = df[np.isfinite(df).all(1)]
df.to_excel(save_path)
df = df.rename(columns={'High mRS': 'target'})

df['target'].value_counts(dropna=False)
print(df.info())
random_seed = 888
df_train, df_test = train_test_split(df, test_size=0.2, random_state=random_seed, stratify=df['target'])


print(df_train.shape)
print(df_test.shape)
print()
print(df_train['target'].value_counts(normalize=True))
print()
print(df_test['target'].value_counts(normalize=True))

numeric_cols = ["Age", "ICH Volume dCT"]
cat_cols = list(set(df.columns) - set(numeric_cols) - {'target'} )
cat_cols.sort()
scaler = StandardScaler()
scaler.fit(df_train[numeric_cols])

def get_features_and_target_arrays(df, numeric_cols, cat_cols, scaler):
    X_numeric_scaled = scaler.transform(df[numeric_cols])
    X_categorical = df[cat_cols].to_numpy()
    X = np.hstack((X_categorical, X_numeric_scaled))
    y = df['target']
    return X, y

X, y = get_features_and_target_arrays(df_train, numeric_cols, cat_cols, scaler)

clf = LogisticRegression(penalty='none', verbose=True) # logistic regression with no penalty term in the cost function.
#clf = LogisticRegressionCV(verbose=1)
clf.fit(X, y)


X_test, y_test = get_features_and_target_arrays(df_test, numeric_cols, cat_cols, scaler)
plot_roc_curve(clf, X_test, y_test)

test_prob = clf.predict_proba(X_test)[:, 1]
test_pred = clf.predict(X_test)
print('Log loss = {:.5f}'.format(log_loss(y_test, test_prob)))
print('AUC = {:.5f}'.format(roc_auc_score(y_test, test_prob)))
print('Average Precision = {:.5f}'.format(average_precision_score(y_test, test_prob)))
print('\nUsing 0.5 as threshold:')
print('Accuracy = {:.5f}'.format(accuracy_score(y_test, test_pred)))
print('Precision = {:.5f}'.format(precision_score(y_test, test_pred)))
print('Recall = {:.5f}'.format(recall_score(y_test, test_pred)))
print('F1 score = {:.5f}'.format(f1_score(y_test, test_pred)))

print('\nClassification Report')
print(classification_report(y_test, test_pred))

coefficients = np.hstack((clf.intercept_, clf.coef_[0]))
coef = pd.DataFrame(data={'variable': ['intercept'] + cat_cols + numeric_cols, 'coefficient': coefficients})
print(coef)


# use statsmethods 
import pandas as pd 
import numpy as np 
import statsmodels.api as sm 
#X = sm.add_constant(X) 
est = sm.OLS(y, X).fit() 
print(est.summary())
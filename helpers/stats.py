import pandas as pd
import numpy as np
import math
from statsmodels.formula.api import ols
import pingouin as pg
from statsmodels.stats import multitest



def calculate_cohens_d(data, nucleus):
    '''
    Calculates Cohen's d to estimate effect sizes.
    data: pandas df
    nucleus: name of nucleus, e.g., 'Medial'
    '''
    
    g1 = data[data['blsgroup'] == 1]
    g2 = data[data['blsgroup'] == 2]
    
    # preterm stats
    mean1 = g1[nucleus].mean()
    std1 = g1[nucleus].std()
    n1 = g1[nucleus].count()
        
    # fullterm stats
    mean2 = g2[nucleus].mean()
    std2 = g2[nucleus].std()
    n2 = g2[nucleus].count()
        
    # cohen's d calculation
    pooled_std = math.sqrt(((n1-1)*std1**2 + (n2-1)*std2**2) / (n1 + n2 - 2))
    cohen_d = (mean1 - mean2) / pooled_std
    
    return cohen_d



def my_ancova(rois, data, covars):
    '''
    Performs an ANCOVA between VP/VLBW and FT subjects, using sex, age, and eTIV as covariates.
    rois: list of rois (e.g., thalamic subregions)
    data: pd dataframe containing the information for the ROIs above
    covars: list of covars (e.g., ['sex', 'Age_at_scan', 'TIV_corrected'])
    '''
    # create empty lists to store output
    ancova_pvals = []
    ancova_fvals = []
    cohens_d_list = []

    # perform ancova for each roi
    for roi in rois:
        ancova = pg.ancova(data=data, dv=roi, between='blsgroup', covar=covars, effsize='np2')
        ancova_pvals.append(ancova['p-unc'][0])
        ancova_fvals.append(ancova['F'][0])
        
        # calculate cohen's d
        cohens_d_val = calculate_cohens_d(data, roi)
        cohens_d_list.append(cohens_d_val)
        
        
    # perform correction for multiple comparisons
    fdr_ancova = multitest.fdrcorrection(ancova_pvals)[1]

    # save summary df
    ancova_results = pd.DataFrame({'roi': rois, 'F-value': ancova_fvals,'p-value': ancova_pvals,
                                   'p-fdr': fdr_ancova, 'Cohens d': cohens_d_list})
    
    ancova_results.reset_index(drop=True, inplace=True)  

    return ancova_results



def association_with_volume(nucleus, var, data):
    model = ols(f'{nucleus} ~ {var} + sex + Age_at_scan + TIV_corrected', data=data).fit()
    
    
    summary_dict = {'variable': var,
                    'nucleus': nucleus,
                    'Tstatistic': model.tvalues[1],
                    'coef': model.params[1], # coefficient term (i.e., beta) for x
                    'R2': model.rsquared, 
                    'pvalue': model.pvalues[1]
                   }
    
    summary_df = pd.DataFrame(summary_dict, index=[0])
    return summary_df





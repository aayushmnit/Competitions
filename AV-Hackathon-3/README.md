##### Codes for Analytics Vidhya Online Hackathon 3.0 - Find the Next Brain Wong !

http://discuss.analyticsvidhya.com/t/online-hackathon-3-0-find-the-next-brain-wong/2838

###### My approach for the hackathon is as follows:

1.  I looked into levels of data and created a data dictionary by mentioning the level gaps, as I figured out that there is difference in level of data in training and testing data set (Like some cities are only in training dataset but are missing from testing and vice versa)

2.  Ran a simple linear model to see if some of the greater number of level categories are impacting the funding and found that state column have some impact on the valuation

3. Converted some of the categorical variables into 1/0 encoded variables

4. Ran R part over Similar project valuation to see it's impact on subsequent funding and found that there is significant shift in mean values with Similar project valuation >$549 and <$549

5. Made two Random forest models with Similar project valuation >$549 and <$549, simply merged there result for the final output

Notes for Datafest 2021 Talk
=======================

If you are downloading a single data file once, it may make sense to ignore APIs.  Instead just manually download the file and manually move it to the appropriate directory.  --But it's rarely one-and-done in our world.

It's rarely one-and-done for many reasons, such as:

* the larger dataset contains dozens of files, or
* the covid dataset is updated with relevant & fresh information daily, or
* you run it on a different computer a few months later, or *and this is the heart of reproducibility*
* you want someone else to be able to effortlessly produce the same analysis using the same dataset.

Instead of telling your students or colleagues "first go to this site, then download these files, then move the files to this these subdirectories, and finally convert them to this format before you run these models" ...say it with ten lines of code.

The Dataverse clients for R and Python allow you to do just that.  You use simple code to replace tedious & error-prone manual steps to facilitate reproducibility of analyses.  The R & Python packages have the narrow goal of interacting with the server to acquire (and possibly transform) datasets, but then get out of the way so the data can be piped into the many analytical packages offered in each language.

The Dataverse server software offers several different options to transfer a dataset as Phil just demonstrated.  The R & Python clients accommodate most or all of them.  But for today we'll show just two common approaches.  The documentation and vignettes demonstrate more options and approaches.

Slide 17 displays our goal -which is the dataframe in R that's ready to be analyzed.  Let's jump back a little to see one way to get here, as shown on slide 18:

* Lines 10 & 11 load the packages
* Then the exact version of a specific data file is specified on lines 13 & 15.
* Remember that a dataverse data*set* may contain multiple files.  On lines 17 through 21, these contents are retrieved and inspected.
* The crucial line is 23.  It's a function that transfers that rectangle of data from the server to your machine.
* At this point, it's just text, until line 25 parses the string and converts it into an R dataframe.  Which can be viewed as in the previous slide.

If you're a Dataverse beginner, consider if you want to use the web browser --instead of R-- to explore the dataset and identify the specific datafile you want.  Also I should mention that Shiro Kuriwaki just added some new functions that essentially combine lines 23 & 25.

And here is Stefan, the developer of the Python module.
.. _introduction:


************
Introduction
************

Documentation on the rationale, Waf, and more background is at http://hmgaudecker.github.io/econ-project-templates/ in the context of the Python version of this template. 

Most of the things mentioned there are valid for the R version of the template as well, only the example is different. Here, I use part of the data of my gift-giving project.



.. _getting_started:

Getting started
===============

**I have completed the steps in the** `README.md file <https://github.com/hmgaudecker/econ-project-templates/tree/R#templates-for-reproducible-research-projects-in-economics>`_ **and everything worked.**

The logic of the project template works by step of the analysis: 

1. Data management
2. The actual analysis
3. Visualisation and results formatting (e.g. exporting of LaTeX figure)
4. Research paper and presentations. 
   


First of all, I moved my source data to **src/original_data/** and started filling up the actual steps of the project workflow (data management, analysis, final steps, paper). I specified the actions in the wscript that lives in the same directory as my main source file. I made sure to understand how the paths work in Waf and how to use the auto-generated files in R (see the section on :ref:`project_paths`).


.. _dag:

DAG of the project
==================



.. raw:: latex
    
    \vspace*{2ex}

    Forget about the previous sentence in the context of this pdf document because in LaTeX, we can include the pdf directly as a graphic:\\[2ex]
    \includegraphics{../dependency_graph.pdf}

This is the framework about how I worked on this project.


.. _project_paths:

Project paths
=============

A variety of project paths are defined in the top-level wscript file. These are exported to be used in header files in other languages. 

The following is taken from the top-level wscript file. I modified any project-wide path settings there.

.. literalinclude:: ../../wscript
    :start-after: out = 'bld'
    :end-before:     # Convert the directories into Waf nodes

As should be evident from the similarity of the names, the paths follow the steps of the analysis in the :file:`src` directory:

    1. **data_management** → **OUT_DATA**
    2. **analysis** → **OUT_ANALYSIS**
    3. **final** → **OUT_FINAL**, **OUT_FIGURES**, **OUT_TABLES**

These will re-appear in automatically generated header files by calling the ``write_project_paths`` task generator.

By default, these header files are generated in the top-level build directory, i.e. ``bld``. Since this is where R is launched, I just get variables with the project paths by adding a line ``source("project_paths.r")`` at the top of my R-scripts. 

To see what these variables are, here is the content of *bld/project_paths.r*:
    
.. literalinclude:: ../../bld/project_paths.r

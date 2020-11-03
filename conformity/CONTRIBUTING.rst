Contributing
============

Contributions are welcome, and they are greatly appreciated! Every little bit helps, and credit will always be given.

You can contribute in many ways:

Types of Contributions
----------------------

Report Bugs
~~~~~~~~~~~

Report bugs at https://github.com/eventbrite/conformity/issues.

If you are reporting a bug, please include:

* Your operating system name and version.
* Your Python interpreter type and version.
* Any details about your local setup that might be helpful in troubleshooting.
* Detailed steps to reproduce the bug.

Fix Bugs
~~~~~~~~

Look through the GitHub issues for bugs. Anything tagged with "bug" is open to whoever wants to fix it.

Implement Features
~~~~~~~~~~~~~~~~~~

Look through the GitHub issues for features. Anything tagged with "feature" is open to whoever wants to implement it.

Write Documentation
~~~~~~~~~~~~~~~~~~~

Conformity could always use more documentation, whether as part of the official Conformity docs, in docstrings, or even
on the web in blog posts, articles, and more.

Submit Feedback
~~~~~~~~~~~~~~~

The best way to send feedback is to file an issue at https://github.com/eventbrite/conformity/issues.

If you are proposing a feature:

* Explain in detail how it would work.
* Keep the scope as narrow as possible, to make it easier to implement.
* Remember that contributions are welcome. :)

Get Started
-----------

Ready to contribute? Here's how to set up Conformity for local development.

1. Fork the ``conformity`` repository on GitHub.
2. Clone your fork locally::

       $ git clone git@github.com:your_name_here/conformity.git

3. Create Python 2.7 and 3.7 virtualenvs (you should ``pip install virtualenvwrapper`` on your system if you have not
   already) for installing Conformity dependencies::

       $ mkvirtualenv2 conformity2
       (conformity2) $ pip install -e .[testing]
       (conformity2) $ deactivate
       $ mkvirtualenv3 conformity3
       (conformity3) $ pip install -e .[testing]
       (conformity3) $ deactivate

4. Make sure the tests pass on master before making any changes; otherwise, you might have an environment issue::

       (conformity2) $ pytest
       (conformity3) $ pytest

5. Create a branch for local development::

       $ git checkout -b name-of-your-bugfix-or-feature

   Now you can make your changes locally.

5. As you make changes, and when you are done making changes, regularly check that Flake8 and MyPy analysis and all of
   the tests pass. You should also include new tests or assertions to validate your new or changed code::

       # flake8 may need to be run within a virtualenv, depending on your setup, but is shown here without
       $ flake8-python2
       $ flake8-python3
       (conformity2) $ pytest
       (conformity3) $ pytest
       (conformity3) $ mypy .

       # to run a subset of tests
       (conformity3) $ pytest path/to/test/folder
       (conformity3) $ pytest path/to/test/module.py
       (conformity3) $ pytest -k name_of_module.py
       (conformity3) $ pytest -k NameOfTestClass
       (conformity3) $ pytest -k name_of_test_function_or_method

   You can also take advantage of the Tox setup to run all of the tests locally in multiple environments using Docker::

       $ ./tox.sh

6. When you think you're ready to commit, run ``isort`` to organize your imports:

       $ isort

7. Commit your changes and push your branch to GitHub::

       $ git add -A
       $ git commit -m "[PATCH] Your detailed description of your changes"
       $ git push origin name-of-your-bugfix-or-feature

   Commit messages should start with ``[PATCH]`` for bug fixes that don't impact the *public* interface of the library,
   ``[MINOR]`` for changes that add new feature or alter the *public* interface of the library in non-breaking ways,
   or ``[MAJOR]`` for any changes that break backwards compatibility. This project strictly adheres to SemVer, so these
   commit prefixes help guide whether a patch, minor, or major release will be tagged. You should strive to avoid
   ``[MAJOR]`` changes, as they will not be released until the next major milestone, which could be as much as a year
   away.

8. Submit a pull request through the GitHub website.

Pull Request Guidelines
-----------------------

Before you submit a pull request, check that it meets these guidelines:

1. The pull request should include tests.
2. If the pull request adds functionality, the documentation should be updated. Put your new functionality into a
   class or function with a docstring, and add the feature to the appropriate location in ``docs/``. If you created a
   new module and it contains classes that should be publicly documented, add an autodoc config for that module to
   ``docs/reference.rst``.
3. The pull request should work for Python 2.7, 3.5, 3.6, and 3.7. Check
   https://travis-ci.org/eventbrite/conformity/pull_requests and make sure that the tests pass for all supported Python
   versions.

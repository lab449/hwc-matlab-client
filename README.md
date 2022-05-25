# HDU Getting started

Status of HDU Homework Checker:  
    <img src="https://i.imgur.com/s50aPvE.png" alt="submit" width="3%"/> **not available**
<!--     <img src="https://i.imgur.com/XtUlbdX.png" alt="submit" width="3%"/> **available** -->

## Installation

1. Create new working directory and open matlab here.  
2. Download CHDU Lab checker using matlab Git Project:  
    ```
    HOME -> New -> Project -> From Git
    ```
    <img src="https://i.imgur.com/1SvD4lu.png" alt="From GIT" width="70%"/>

3. Type into __Repository path__: https://github.com/ITMORobotics/hwc-matlab-client.git, and choose working directory in field __Sansdbox__ and click __Retrieve__:  
    <img src="https://i.imgur.com/hoOAq5f.png" alt="github" width="95%"/>
4. Choose project name and submit project creating:  
    <img src="https://i.imgur.com/WGze49L.png" alt="submit" width="75%"/>

5. Later for openning the project you can use:  
    ```
    Open -> Recent -> Your Project
    ```
    <img src="https://i.imgur.com/5j19zWW.png" alt="submit" width="90%"/>
    
## Registration
1. To start doing lab work, you must register in the system. To do this, enter in the Matlab console:  
    ```python
    chdu = chdu_connect()
    ```
2. Fill in *Full name* and click __Enter__. After that fill in other required fields:  
    <img src="https://i.imgur.com/rbiY3JD.png" alt="submit" width="80%"/>
    
    Check your EMail for getting authentification token:  
    <img src="https://i.imgur.com/UYVTS1l.png" alt="submit" width="90%"/>
    
    Enter this token:  
    <img src="https://i.imgur.com/Fqgxtuv.png" alt="submit" width="80%"/>

## Usage

After registration you can connect at any time with   
```python
chdu = chdu_connect()
```

For getting first task(lab) you must type:  
```python
task = chdu.get_task(1)
```

For other tasks(labs) you must type desired number:  
```python
task = chdu.get_task(laboratory_number)
```

The case will be generated on the first call. After that, you can retrieve your task at any time with  
```python
task = chdu.get_task(laboratory_number)
```

<img src="https://i.imgur.com/l8p7nNc.png" alt="task" width="79%"/>

There is your task. In task structure you can see in variable  __files__ associated filenames. In this case: *l1_1.pdf*. This file contains in folder __files__.  

In struct __parameters__ presented input variables for modeling the system described in *pdf* file:  
<img src="https://i.imgur.com/uFzZEGO.png" alt="task_parameters" width="79%"/>

In struct __answers__ presented variables that you must fill instead of __?__:  
<img src="https://i.imgur.com/6OUihVT.png" alt="task_answers" width="79%"/>

When you fill all variables in struct __answers__ instead of __?__ you can check it with:
```python
chdu.send_task(task)
```
<img src="https://i.imgur.com/MkJOnrn.png" alt="task_send" width="79%"/>

You are right if you have nonzero score opposite the corresponding variable. The total score is the sum of all scores. You can also see the number of attempts.

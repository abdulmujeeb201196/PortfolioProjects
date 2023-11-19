# -*- coding: utf-8 -*-
"""
Created on Fri Nov 10 16:47:19 2023

@author: Abdul
"""


number =None
number_2 =None
weight_in_pounds = 1
height = 1
def wei(weight_in_pounds):
    while number is None:
        try:
        
            weight = int(input("Please enter your weight in kgs: "))
            weight_inpounds = weight * (2.20462262)
            weight_in_pounds = round(weight_inpounds, 2)
            print("Weight In Pounds : ", weight_in_pounds)
            input()
        except ValueError:
            print("Please input valid number")
            
        break               


def hei(height):
    while number_2 is None:
        try:
            height = int(input("Please enter your height in inches: "))
        except ValueError:
            print("Please input valid number")
        break               

#def main():
    
name = input("Please enter your name : " )    
wei(weight_in_pounds)
hei(height)

BMI = (weight_in_pounds  * 703) / (height * height)
print("BMI: ", BMI)  
name = input("Please enter your name: " )
if (BMI>0):
    if(BMI<18.5):
        print(name + ", You are underweight.")
    elif(BMI<=24.9):
        print(name + ", You are normal weight.") 
    elif(BMI<=29.9):
        print(name + ", You are overweight.") 
    elif(BMI<=34.9):
        print(name + ", You are obese.") 
    elif(BMI<=39.9):
        print(name + ", You are severely obese.")     
else:
    print(name + ", You are morbidly obese.") 
               
    
   # try:
    #    main()
     #   input() 
   # except KeyboardInterrupt:
   #     pass  
        
                

                
                    
                            
                            
                            
                          
               
              
            
        
             
    
        
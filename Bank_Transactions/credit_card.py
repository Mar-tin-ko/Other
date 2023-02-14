# Import packages
from datetime import datetime

def collect_card():
    '''''
    Function that collects basic credit card information
    with simple input error handling. It returns the credit
    card number from user input.
    '''''
    # Collect credit card number
    while True:
        input_val = input("Please enter your credit the number: ")
        # Check if the input is a number
        try:
            if (len(input_val) == 13 or len(input_val) == 15 or len(input_val) == 16):
                break
            else:
                print("You entered invalid card number! Please try again.")
        except:
            pass  # In case of string the loop continues

    # Collect the cardholder's name
    while True:
        cardholder = input("Please enter the card holder name: ")
        # Check if the input is a alphanumeric but has no digits
        try:
            if all(element.isalnum() or element == ' ' for element in cardholder) and not any(element.isdigit() for element in cardholder):
                break
            else:
                print("You entered invalid name! Please try again.")
        except:
            pass  # In case of string the loop continues

    # Collect the card expiration date
    while True:
        year = int(input("Please enter the expiration year: "))
        month = int(input("Please enter the expiration month: "))
        # Check if the input is a alphanumeric but has no digits
        current_year = datetime.now().year
        current_month = datetime.now().month
        try:
            if year == current_year and month >= current_month  and month <= 12:
                return input_val  # Return commands ends the function so it can not be put in the card number user input section
                break
            elif year > current_year and year <= current_year + 4 and month >= 1 and month <= 12:
                return input_val  # Return commands ends the function so it can not be put in the card number user input section
                break
            else:
                print("You entered invalid expiration data! Please try again.")
        except:
            pass  # In case of string the loop continues


def check_card(input_val):
    '''''
    Function that checks if the card number entered by user
    is a real credit card number and which company has 
    produced the card. It returns indication boolean variable
    stating whether the card was charged successfully 
    to increase the current account's balance or not.
    '''''
    # Use common algorithms to determine if the card number is real and who is the card's producer
    if len(input_val) % 2 == 0:  # Based on the length of card number select the digits
        odd_numbers = [value for index, value in enumerate(input_val) if index % 2 == 0]
    else:
        odd_numbers = [value for index, value in enumerate(input_val) if index % 2 == 1]
    # print("odd nums :", odd_numbers)
    sum_list = []
    for i in range(len(odd_numbers)):
        sum_list.append(2 * int(odd_numbers[i]))
    # print("odd nums dobled : ", sum_list)

    sum_list_2 = []
    for m in range(len(sum_list)):
        sum_list_2.extend(list(str(sum_list[m])))
    # print(sum_list_2)

    sum = 0
    for z in range(len(sum_list_2)):
        sum += int(sum_list_2[z])
    # print("sum is first: ", sum)

    if len(input_val) % 2 == 0:  # Based on the length of card number select the digits
        rest_numbers = [value for index, value in enumerate(input_val) if index % 2 == 1]
    else:
        rest_numbers = [value for index, value in enumerate(input_val) if index % 2 == 0]
    # print("rest nums :", rest_numbers)
    for k in rest_numbers:
        sum += int(k)

    # print("sum is final: ", sum)
    # print(repr(sum)[-1])

    # Determine default value of the indication boolean variable
    card_charged = False
    # Assessment of the card number validity
    if int(repr(sum)[-1]) != 0:  # Valid card number ends with digit 0
        print("The card number you entered is INVALID! Please try again to use the credit card.")
        return card_charged
    else:  # Determine the credit card producer
        if input_val[0] == str(4):
            print("Your VISA card is valid and was successfully charged!")
            card_charged = True
            return card_charged
        elif input_val[0] == str(3) and (input_val[1] == str(4) or input_val[1] == str(7)):
            print("Your AMEX card is valid and was successfully charged!")
            card_charged = True
            return card_charged
        elif input_val[0] == str(5) and (int(input_val[1]) > 0 and int(input_val[1]) < 6):
            print("Your MASTERCARD card is valid and was successfully charged!")
            card_charged = True
            return card_charged
        else:
            print("Your card is INVALID! Please try again to use the credit card.")
            return card_charged


#card_nr = collect_card()
#print(card_nr)
#check_card(card_nr)
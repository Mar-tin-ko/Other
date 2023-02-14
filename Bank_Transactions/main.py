"""""""""""""""""""""""""""""""""""""""""""""""""""""""""
Author: Mar-tin-ko
Created: September 2021
Functionality: bank transactions, encryption, decryption, 
check of credit card number and producer
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""

# Import packages and files
import transfer
import credit_card

# Internet Banking System Data
balance_current = 9473.19
balance_saving = 100.0
print('Welcome to your internet banking application. \n'
      'Your current account balance is ', balance_current, ' EUR. \n'
      'Your saving account balance is ', balance_saving, ' EUR. \n')

# Function that automizes basic error handling for user inputs for banking actions
def ask_question(query):
    '''''
    Function that asks the user banking action questions and 
    returns allowed answers only (Y / YES / N / NO).
    '''''
    while True:
        action = input(query)
        # Input handling
        if action.upper() in ('Y', 'YES', 'N', 'NO'):
            break  # If the answer is allowed
        else:
            print("\nYou entered incorrect command! Please try again.")
            pass # Going back to infinite while loop
    return action

# Define banking actions via questions
query1 = '\nWould you like to TRANSFER money between your accounts? Y/N'
query2 = '\nWould you like to ADD MONEY to your current balance with a credit card? Y/N'
query3 = '\nWould you like to END this session? Y/N'

# Create infinite loop for repeating the banking action questions until the loop is deliberately ended by user
while True:
    if ask_question(query1).upper() in ('Y', 'YES'):
        try:
            donor_name, donor, acceptor_name, acceptor = transfer.perform_transaction(balance_current, balance_saving)
            print('Your transaction was performed successfully!')
            print('Your', donor_name, 'is now: ', donor)
            print('Your', acceptor_name, 'is now: ', acceptor)
            if donor_name == 'current account balance':
                balance_current = donor
                balance_saving = acceptor
            else:
                balance_current = acceptor
                balance_saving = donor
        except:
            pass
    else:  # it is a "NO"
        if ask_question(query2).upper() in ('Y', 'YES'):
            amount = int(transfer.ask_amount())
            while True:
                card_nr = credit_card.collect_card()
                card_charged = str(credit_card.check_card(card_nr))
                if card_charged == str(True):
                    balance_current += amount
                    print('The balance of your current account is', balance_current)
                    break
                else:
                    pass
        else:  # it is a "NO"
            if ask_question(query3).upper() in ('Y', 'YES'):
                print('Your session has ended. Thank you for using our services & have a nice day!')
                break











# Import files
import tokenization


def perform_transaction(balance_current, balance_saving):
    '''''
    Function to perform transaction between current and saving account
    based on transaction direction.
    '''''
    # Run functions and convert their user's inputs to integers
    direction = int(define_transaction())

    if direction == 9:
        print('Your session has ended. Thank you for using our services & have a nice day!')

    elif direction == 1:
        amount = int(ask_amount())
        donor_name, donor, acceptor_name, acceptor = transaction(amount, balance_current, balance_saving, 'current account balance', 'saving account balance')
        return donor_name, donor, acceptor_name, acceptor

    else:  # direction is 2
        amount = int(ask_amount())
        donor_name, donor, acceptor_name, acceptor = transaction(amount, balance_saving, balance_current, 'saving account balance', 'current account balance')
        return donor_name, donor, acceptor_name, acceptor


def define_transaction():
    '''''
    Function that returns a valid transaction direction (type) from user's input.
    '''''
    # Input handling
    while True:
        direction = input("To transfer money from your CURRENT account to your SAVING account press 1. \n"
                          "To transfer money from your SAVING account to your CURRENT account press 2. \n"
                          "To quit the operation press 9. \n")
        # Check if the input is a number
        allowed = [1, 2, 9]
        try:
            if (int(direction) in allowed) and type(int(direction)) == int:
                return direction
                break
            else:
                print("You did not enter a valid answer! Please try again.")
        except:
            print("You did not enter a valid answer! Please try again.")
            pass  # In case of string the loop continues


def ask_amount():
    '''''
    Function that returns a valid transaction amount from user's input.
    '''''
    # Input handling
    while True:
        amount = input("Please enter the amount (whole number) to be transferred: ")
        # Check if the input is a number
        try:
            if type(int(amount)) == int:
                return amount
                break
        except:
            print("\nYou did not enter an integer number!")
            pass  # In case of string the loop continues


def transaction(amount, donor, acceptor, donor_name, acceptor_name):
    '''''
    Function that returns updated amount of the current and saving balances.
    '''''
    if amount <= donor:
        token = tokenization.tokenize()
        token_input = input("Please confirm the token that was sent to you by bank:")
        if token_input == token[0]:  # This is comparison of strings!
            print('You have successfully confirmed the token!')
            donor -= amount
            acceptor += amount
            # print('Your', donor_name, 'account is now: ', donor)
            # print('Your', acceptor_name, 'account is now: ', acceptor)
            return donor_name, donor, acceptor_name, acceptor
        else:
            print('\nYou entered incorrect token! Please perform the transaction from the start again.\n')
            # Restart the transaction cycle
            perform_transaction(donor, acceptor)
    else:
        print('\nYou have not sufficient funds on your account to perform this transaction!\n')
        print('\nYou have not sufficient funds on your account to perform this transaction!\n')
        # Ask again for correct amount value or to end the user request
        perform_transaction(donor, acceptor)


# Import packages
import string

# Define the shifting parameter for crypting
shift_parameter = 14

# Create function to count the digits, special characters, spaces and all other characters of a text
def message_structure(text):
    '''''
    Function that generates random token and uses function from 
    cryption file to secure the message.
    '''''
    # Define digits and special characters
    all_digits = ['0', '1', '2', '3', '4', '5', '6', '7', '8', '9']
    all_specials = ['.', ',', ';', '!', '?', '_', '-', '+', '*', '/', '=', '<', '>', '(', ')', '#', '§', '%', '&']

    # Set up counting parameters
    nr_digits = 0
    nr_spaces = 0
    nr_specials = 0
    nr_chars = 0

    for i in text:
        if i in all_digits:
            nr_digits += 1
        elif i == " ":
            nr_spaces += 1
        elif i in all_specials:
            nr_specials += 1
        else:
            nr_chars += 1
    return nr_chars, nr_digits, nr_specials, nr_spaces

# Create message object
class Message(object):
    # Initialization and definition of attributes
    def __init__(self, content):
        self.message_content = content
        self.message_length = len(content)
        self.message_chars = message_structure(content)[0]
        self.message_digits = message_structure(content)[1]

    # Define crypting method with shifting parameter
    def crypting(self, shift):
        message = self.message_content
        # Create ditionary for alphabet
        alphabet = string.ascii_lowercase + string.ascii_uppercase \
                    + string.digits + string.punctuation
        alphabet_dict= {}
        for i in range(0, len(alphabet)):
            alphabet_dict[alphabet[i]] = i + 1
    
        # print(alphabet_dict)
        last_key = list(alphabet_dict)[-1]
        alphabet_dict[' '] = alphabet_dict[last_key] + 1
        # print('My alphabet dictionary has ', len(alphabet_dict), ' elements')

        # Convert the message to alphabet's dictionary values
        original_numbers = []
        for k in list(message):
            original_numbers.append(alphabet_dict[k]) 
        # print(original_numbers)

        # Shift the dictionary values of the message by the inputted shifting parameter
        shifted_numbers = []
        for i in range(len(original_numbers)):
            if original_numbers[i] + shift > len(alphabet_dict):
                shifted_numbers.append(original_numbers[i] + shift -len(alphabet_dict))
            else:
                shifted_numbers.append(original_numbers[i] + shift)
        # print(shifted_numbers)

        # Create vector for crypted message by converting from the dictionary values (digits) to characters
        crypted = []
        for i in range(len(shifted_numbers)):
            crypted.append(list(alphabet_dict.keys())[shifted_numbers[i]-1])
        return crypted





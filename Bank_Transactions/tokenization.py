# Import packages and files
import random
import re
import cryption


def tokenize():
    '''''
    Function that generates random token and uses function from 
    cryption file to secure the message.
    '''''
    # Bank generates original message with token for its client
    token = round(random.random() * 1000000)  # 6 digit token random generator
    text = 'Your security code is '
    text_message = text + str(token)
    bank_msg = cryption.Message(text_message)
    # print('Original bank message: ', bank_msg.message_content)
    # print('<Metadata: Message is of length', bank_msg.message_length, 'thereof ', bank_msg.message_chars, ' characters and', \
    #      bank_msg.message_digits, 'digits.> \n', )

    # Bank's security communication system prepares ENCRYPTED message and sends it to client
    encrypted_msg = bank_msg.crypting(cryption.shift_parameter)
    encrypted_msg = ''.join(encrypted_msg)
    print('<< Encrypted bank message: ', encrypted_msg, '>>')

    # Client's bank application converts it to DECRYPTED message
    encrypted_msg = cryption.Message(encrypted_msg)
    decrypted_msg = encrypted_msg.crypting(-cryption.shift_parameter)
    decrypted_msg = ''.join(decrypted_msg)
    print('<< Decrypted bank message: ', decrypted_msg, '>>')

    # Extract the token form the bank's text message
    # from https://www.askpython.com/python/string/extract-digits-from-python-string
    token = re.findall(r'\d+', decrypted_msg)
    return token

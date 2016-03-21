Braintree::Configuration.environment = :sandbox #:sandbox#production
Braintree::Configuration.logger = Logger.new('log/braintree.log')
#FAKE SHIT
Braintree::Configuration.merchant_id = 'n25tvnzzsmbx675x'#ENV['BRAINTREE_MERCHANT_ID']
Braintree::Configuration.public_key = 'mw4c263nbmz83rfm'#ENV['BRAINTREE_PUBLIC_KEY']
Braintree::Configuration.private_key = '0345f1f1e06a7d5f3c4304d2e0d1e922'#ENV['BRAINTREE_PRIVATE_KEY']

#REAL SHIT
#Braintree::Configuration.merchant_id = 'fqmh5bkjbcbz5t57'#ENV['BRAINTREE_MERCHANT_ID']
#Braintree::Configuration.public_key = 'z2ddq3cqkf4kbtzt'#ENV['BRAINTREE_PUBLIC_KEY']
#Braintree::Configuration.private_key = '0b451d6104a672ee425fc44fe244588f'#ENV['BRAINTREE_PRIVATE_KEY']

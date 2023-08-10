import { Flex, Center, Text, Square, Box, Spacer, Heading, HStack, Button, VStack, Input, InputGroup, InputLeftAddon } from '@chakra-ui/react';

export default function Buy() {
  return (
    <>
      <Flex color='white' flexDir='column' px="8" py="16" borderRadius="6" width="60%" >
        <VStack>
          <HStack justify='space-between' w='100%'>
            <Text fontWeight="normal" color="gray.600" mb="4">Price per Ticket</Text>
            <Text textAlign='right' color="gray.600"> 0.01 MATIC</Text>
          </HStack>
          <InputGroup mb="4">
            <InputLeftAddon children='TICKETS' fontWeight="normal" color="gray.600" />
            <Input type='num' placeholder='5' textAlign='right'
              color="gray.600" />
          </InputGroup>
          <VStack width="100%" my="4">
            <HStack justify='space-between' w='100%'>
              <Text fontWeight="normal" color="gray.600"> Total Cost of Tickets</Text>
              <Text textAlign='right' color="gray.600">0.05 MATIC</Text>
            </HStack>
            <HStack justify='space-between' w='100%'>
              <Text fontWeight="normal" color="gray.600"> Service Fees</Text>
              <Text textAlign='right' color="gray.600">0.005 MATIC</Text>
            </HStack>
            <HStack justify='space-between' w='100%'>
              <Text fontWeight="normal" color="gray.600"> + Network Fees</Text>
              <Text textAlign='right' color="gray.600">TBC</Text>
            </HStack>
          </VStack>
          <Button width="100%"> Buy 5 ticket(s) for 0.05 MATIC</Button>
        </VStack>
      </Flex>
    </>
  )
}
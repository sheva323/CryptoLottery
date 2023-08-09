import { Flex, Center, Text, Square, Box, Spacer, Heading, HStack, Button, VStack, Input, InputGroup, InputLeftAddon } from '@chakra-ui/react';

export default function Buy() {
  return (
    <>
      <Flex color='white' bg="yellow.600" flexDir='column' w="30%" px="8" py="16" borderRadius="6">
        <VStack>
          <HStack justify='space-between' w='100%'>
            <Text>Price per Ticket</Text>
            <Text> 0.01 MATIC</Text>
          </HStack>
          <InputGroup>
            <InputLeftAddon children='TICKETS' />
            <Input type='num' placeholder='5' textAlign='right' />
          </InputGroup>
          <VStack>
            <HStack justify='space-between' w='100%'>
              <Text> Total Cost of Tickets</Text>
              <Text textAlign='right'>0.05 MATIC</Text>
            </HStack>
            <HStack justify='space-between' w='100%'>
              <Text> Service Fees</Text>
              <Text textAlign='right'>0.005 MATIC</Text>
            </HStack>
            <HStack justify='space-between' w='100%'>
              <Text> + Network Fees</Text>
              <Text textAlign='right'>TBC</Text>
            </HStack>
          </VStack>
          <Button> Buy 5 ticket(s) for 0.05 MATIC</Button>
        </VStack>
      </Flex>
    </>
  )
}
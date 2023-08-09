import { Flex, Center, Text, Square, Box, Spacer, Heading, HStack, VStack } from '@chakra-ui/react';

export default function Counter() {
  return (
    <>
      <Flex color='white' bg="yellow.600" flexDir='column' w="40%" px="8" py="16" borderRadius="6">
        <Heading textAlign='center' mb='4'>The next draw</Heading>
        <Flex justify='space-between'>
          <Flex borderColor="red.500" borderWidth="1px" flexDir='column' borderRadius="6" px="6" py="2" textAlign={'left'}>
            <Text fontSize='sm'>Total Pool</Text>
            <Text fontWeight={'bold'}> 0.01 MATIC</Text>
          </Flex>
          <Flex borderColor="red.500" borderWidth="1px" flexDir='column' borderRadius="6" px="6" py="2" textAlign={'left'}>
            <Text fontSize='sm'>Total Pool</Text>
            <Text fontWeight={'bold'}> 0.01 MATIC</Text>
          </Flex>
        </Flex>
        <Center mt="8">
          <HStack width="100%" justifyContent="space-between">
            <VStack>
              <Box borderColor="red.500" borderWidth="1px" px="8" py="4" borderRadius="6"><Heading>0</Heading></Box>
              <Text >HOURS</Text>
            </VStack>
            <VStack px="4" py="4" >
              <Box borderColor="red.500" borderWidth="1px" px="8" py="4" borderRadius="6"><Heading>0</Heading></Box>
              <Text>MINUTES</Text>
            </VStack>
            <VStack px="4" py="4">
              <Box borderColor="red.500" borderWidth="1px" px="8" py="4" borderRadius="6"><Heading>0</Heading></Box>
              <Text>SECONDS</Text>
            </VStack>
          </HStack>
        </Center>
      </Flex>
    </>
  )
}
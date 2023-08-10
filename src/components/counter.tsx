import { Flex, Center, Text, Square, Box, Spacer, Heading, HStack, VStack } from '@chakra-ui/react';

export default function Counter() {
  return (
    <>
      <Flex color='white' w={{ base: '90%', md: '80%' }} px="8" py="4" borderRadius="6" justify='space-between' flexDirection={{ base: 'column', md: 'row' }}>
        <Flex justify='space-around' align="center" w={{ base: '100%', md: '50%' }}>
          <Flex borderColor="gray.200" borderWidth="1px" flexDir='column' borderRadius="6" px="8" py="6" textAlign={'left'} color="gray.700">
            <Text fontSize='sm' fontWeight="light">Total Pool</Text>
            <Text fontWeight={'bold'}> 0.01 MATIC</Text>
          </Flex>
          <Flex borderColor="gray.200" borderWidth="1px" flexDir='column' borderRadius="6" px="8" py="6" textAlign={'left'} color="gray.700">
            <Text fontSize='sm'>Total Pool</Text>
            <Text fontWeight={'bold'}> 0.01 MATIC</Text>
          </Flex>
        </Flex>
        <HStack w={{ base: '100%', md: '40%' }} justifyContent="space-between">
          <VStack>
            <Box bg="teal.500" borderWidth="1px" px="8" py="4" borderRadius="6" textAlign="center"><Heading>0</Heading>
              <Text >HOURS</Text>
            </Box>
          </VStack>
          <VStack px="4" py="4" >
            <Box bg="teal.500" borderWidth="1px" px="8" py="4" borderRadius="6" textAlign="center"><Heading>0</Heading>
              <Text>MINUTES</Text>
            </Box>
          </VStack>
          <VStack px="4" py="4">
            <Box bg="teal.500" borderWidth="1px" px="8" py="4" borderRadius="6" textAlign="center"><Heading>0</Heading>
              <Text>SECONDS</Text></Box>
          </VStack>
        </HStack>
      </Flex>
    </>
  )
}
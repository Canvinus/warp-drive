import NftView from '@/components/NFT/nftView'
import PageHead from '@/components/Common/PageHead'
import DefaultAlert from '@/components/Alert/DefaultAlert'
import FlexCenter from '@/components/Common/FlexCenter'
import axios from 'axios'

import { SimpleGrid } from '@chakra-ui/react'
import { useEffect, useState } from 'react'
import { useAccount, useNetwork } from 'wagmi'
import { useToast } from '@chakra-ui/react'

export default function SpacePort() {
  const toast = useToast()
  const [tokens, setTokens] = useState([])
  const { address, isConnected, isDisconnected } = useAccount()
  const { chains } = useNetwork()

  useEffect(() => {
    const fetchData = async () => {
      clearData()
      chains.forEach((chain) => {
        axios
          .get(`/api/moralis/getNfts?chain=${chain.network}&address=${address}`)
          .then((response) => {
            response.data.result.forEach((res) => {
              if (res.token_uri) {
                let tokens = []
                const uri =
                  res.token_uri &&
                  res.token_uri.replace('ipfs.moralis.io:2053', 'ipfs.io')
                axios.get(uri).then((response) => {
                  tokens.push({
                    ...res,
                    chain: chain.network,
                    name: response.data.name,
                    image: response.data.image.replace(
                      'ipfs://',
                      'https://ipfs.io/ipfs/'
                    ),
                  })
                  setTokens((prev) => prev.concat(tokens))
                })
              }
            })
          })
      })
    }

    const clearData = () => {
      setTokens([])
    }

    isDisconnected &&
      toast({
        title: 'Error',
        description: 'Wallet is disconnected!',
        position: 'top',
        status: 'error',
        duration: 9000,
        isClosable: true,
      })

    isConnected && fetchData()
    isDisconnected && clearData()
  }, [isConnected, isDisconnected, address])

  return (
    <>
      <PageHead title="Space Port" />
      <SimpleGrid
        columns={4}
        spacingX={6}
        spacingY={0}
        marginLeft={20}
        marginRight={20}
        paddingBottom={20}
      >
        {tokens.map((token) => {
          return (
            <NftView
              key={token.token_id}
              chainName={token.chain}
              tokenId={token.token_id}
              image={token.image}
              name={token.name}
            />
          )
        })}
      </SimpleGrid>
      <FlexCenter>
        <DefaultAlert
          isOpen={tokens.length === 0}
          status="warning"
          title="Space Port is empty"
          description="Build a ship first"
        />
      </FlexCenter>
    </>
  )
}

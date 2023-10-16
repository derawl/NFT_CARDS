var provider = new ethers.providers.Web3Provider(window.ethereum);
var token = $("#csrf_token").val();
const Trade_abi = [
    {
        inputs: [
            { internalType: "uint8", name: "_buyerFee", type: "uint8" },
            { internalType: "uint8", name: "_sellerFee", type: "uint8" },
            { internalType: "uint8", name: "_partnerFee", type: "uint8" },
            { internalType: "address", name: "_admin1", type: "address" },
            { internalType: "address", name: "_admin2", type: "address" },
            {
                internalType: "contract ITransferProxy",
                name: "_transferProxy",
                type: "address",
            },
        ],
        stateMutability: "nonpayable",
        type: "constructor",
    },
    {
        anonymous: false,
        inputs: [
            {
                indexed: false,
                internalType: "address",
                name: "nftAddress",
                type: "address",
            },
            {
                indexed: true,
                internalType: "address",
                name: "assetOwner",
                type: "address",
            },
            {
                indexed: true,
                internalType: "uint256",
                name: "tokenId",
                type: "uint256",
            },
            {
                indexed: false,
                internalType: "uint256",
                name: "quantity",
                type: "uint256",
            },
            {
                indexed: true,
                internalType: "address",
                name: "buyer",
                type: "address",
            },
        ],
        name: "BuyAsset",
        type: "event",
    },
    {
        anonymous: false,
        inputs: [
            {
                indexed: false,
                internalType: "uint8",
                name: "buyerFee",
                type: "uint8",
            },
        ],
        name: "BuyerFee",
        type: "event",
    },
    {
        anonymous: false,
        inputs: [
            {
                indexed: false,
                internalType: "address",
                name: "nftAddress",
                type: "address",
            },
            {
                indexed: true,
                internalType: "address",
                name: "assetOwner",
                type: "address",
            },
            {
                indexed: true,
                internalType: "uint256",
                name: "tokenId",
                type: "uint256",
            },
            {
                indexed: false,
                internalType: "uint256",
                name: "quantity",
                type: "uint256",
            },
            {
                indexed: true,
                internalType: "address",
                name: "buyer",
                type: "address",
            },
        ],
        name: "ExecuteBid",
        type: "event",
    },
    {
        anonymous: false,
        inputs: [
            {
                indexed: true,
                internalType: "address",
                name: "previousOwner",
                type: "address",
            },
            {
                indexed: true,
                internalType: "address",
                name: "newOwner",
                type: "address",
            },
        ],
        name: "OwnershipTransferred",
        type: "event",
    },
    {
        anonymous: false,
        inputs: [
            {
                indexed: false,
                internalType: "uint8",
                name: "partnerFee",
                type: "uint8",
            },
        ],
        name: "PartnerFee",
        type: "event",
    },
    {
        anonymous: false,
        inputs: [
            {
                indexed: true,
                internalType: "bytes32",
                name: "role",
                type: "bytes32",
            },
            {
                indexed: true,
                internalType: "bytes32",
                name: "previousAdminRole",
                type: "bytes32",
            },
            {
                indexed: true,
                internalType: "bytes32",
                name: "newAdminRole",
                type: "bytes32",
            },
        ],
        name: "RoleAdminChanged",
        type: "event",
    },
    {
        anonymous: false,
        inputs: [
            {
                indexed: true,
                internalType: "bytes32",
                name: "role",
                type: "bytes32",
            },
            {
                indexed: true,
                internalType: "address",
                name: "account",
                type: "address",
            },
            {
                indexed: true,
                internalType: "address",
                name: "sender",
                type: "address",
            },
        ],
        name: "RoleGranted",
        type: "event",
    },
    {
        anonymous: false,
        inputs: [
            {
                indexed: true,
                internalType: "bytes32",
                name: "role",
                type: "bytes32",
            },
            {
                indexed: true,
                internalType: "address",
                name: "account",
                type: "address",
            },
            {
                indexed: true,
                internalType: "address",
                name: "sender",
                type: "address",
            },
        ],
        name: "RoleRevoked",
        type: "event",
    },
    {
        anonymous: false,
        inputs: [
            {
                indexed: false,
                internalType: "uint8",
                name: "sellerFee",
                type: "uint8",
            },
        ],
        name: "SellerFee",
        type: "event",
    },
    {
        inputs: [],
        name: "DEFAULT_ADMIN_ROLE",
        outputs: [{ internalType: "bytes32", name: "", type: "bytes32" }],
        stateMutability: "view",
        type: "function",
    },
    {
        inputs: [],
        name: "admin1",
        outputs: [{ internalType: "address", name: "", type: "address" }],
        stateMutability: "view",
        type: "function",
    },
    {
        inputs: [],
        name: "admin2",
        outputs: [{ internalType: "address", name: "", type: "address" }],
        stateMutability: "view",
        type: "function",
    },
    {
        inputs: [
            {
                components: [
                    {
                        internalType: "address",
                        name: "seller",
                        type: "address",
                    },
                    { internalType: "address", name: "buyer", type: "address" },
                    {
                        internalType: "address",
                        name: "partner",
                        type: "address",
                    },
                    {
                        internalType: "address",
                        name: "erc20Address",
                        type: "address",
                    },
                    {
                        internalType: "address",
                        name: "nftAddress",
                        type: "address",
                    },
                    {
                        internalType: "enum Trade.PartnerFeeType",
                        name: "partnerType",
                        type: "uint8",
                    },
                    {
                        internalType: "uint256",
                        name: "unitPrice",
                        type: "uint256",
                    },
                    {
                        internalType: "uint256",
                        name: "amount",
                        type: "uint256",
                    },
                    {
                        internalType: "uint256",
                        name: "tokenId",
                        type: "uint256",
                    },
                    { internalType: "uint256", name: "qty", type: "uint256" },
                ],
                internalType: "struct Trade.Order",
                name: "order",
                type: "tuple",
            },
            {
                components: [
                    { internalType: "uint8", name: "v", type: "uint8" },
                    { internalType: "bytes32", name: "r", type: "bytes32" },
                    { internalType: "bytes32", name: "s", type: "bytes32" },
                    { internalType: "uint256", name: "nonce", type: "uint256" },
                ],
                internalType: "struct Trade.Sign",
                name: "sign",
                type: "tuple",
            },
        ],
        name: "buyAsset",
        outputs: [{ internalType: "bool", name: "", type: "bool" }],
        stateMutability: "nonpayable",
        type: "function",
    },
    {
        inputs: [],
        name: "buyerServiceFee",
        outputs: [{ internalType: "uint8", name: "", type: "uint8" }],
        stateMutability: "view",
        type: "function",
    },
    {
        inputs: [
            {
                components: [
                    {
                        internalType: "address",
                        name: "seller",
                        type: "address",
                    },
                    { internalType: "address", name: "buyer", type: "address" },
                    {
                        internalType: "address",
                        name: "partner",
                        type: "address",
                    },
                    {
                        internalType: "address",
                        name: "erc20Address",
                        type: "address",
                    },
                    {
                        internalType: "address",
                        name: "nftAddress",
                        type: "address",
                    },
                    {
                        internalType: "enum Trade.PartnerFeeType",
                        name: "partnerType",
                        type: "uint8",
                    },
                    {
                        internalType: "uint256",
                        name: "unitPrice",
                        type: "uint256",
                    },
                    {
                        internalType: "uint256",
                        name: "amount",
                        type: "uint256",
                    },
                    {
                        internalType: "uint256",
                        name: "tokenId",
                        type: "uint256",
                    },
                    { internalType: "uint256", name: "qty", type: "uint256" },
                ],
                internalType: "struct Trade.Order",
                name: "order",
                type: "tuple",
            },
            {
                components: [
                    { internalType: "uint8", name: "v", type: "uint8" },
                    { internalType: "bytes32", name: "r", type: "bytes32" },
                    { internalType: "bytes32", name: "s", type: "bytes32" },
                    { internalType: "uint256", name: "nonce", type: "uint256" },
                ],
                internalType: "struct Trade.Sign",
                name: "sign",
                type: "tuple",
            },
        ],
        name: "executeBid",
        outputs: [{ internalType: "bool", name: "", type: "bool" }],
        stateMutability: "nonpayable",
        type: "function",
    },
    {
        inputs: [{ internalType: "bytes32", name: "role", type: "bytes32" }],
        name: "getRoleAdmin",
        outputs: [{ internalType: "bytes32", name: "", type: "bytes32" }],
        stateMutability: "view",
        type: "function",
    },
    {
        inputs: [
            { internalType: "bytes32", name: "role", type: "bytes32" },
            { internalType: "address", name: "account", type: "address" },
        ],
        name: "grantRole",
        outputs: [],
        stateMutability: "nonpayable",
        type: "function",
    },
    {
        inputs: [
            { internalType: "bytes32", name: "role", type: "bytes32" },
            { internalType: "address", name: "account", type: "address" },
        ],
        name: "hasRole",
        outputs: [{ internalType: "bool", name: "", type: "bool" }],
        stateMutability: "view",
        type: "function",
    },
    {
        inputs: [],
        name: "owner",
        outputs: [{ internalType: "address", name: "", type: "address" }],
        stateMutability: "view",
        type: "function",
    },
    {
        inputs: [],
        name: "partnerServiceFee",
        outputs: [{ internalType: "uint8", name: "", type: "uint8" }],
        stateMutability: "view",
        type: "function",
    },
    {
        inputs: [
            { internalType: "bytes32", name: "role", type: "bytes32" },
            { internalType: "address", name: "account", type: "address" },
        ],
        name: "renounceRole",
        outputs: [],
        stateMutability: "nonpayable",
        type: "function",
    },
    {
        inputs: [
            { internalType: "bytes32", name: "role", type: "bytes32" },
            { internalType: "address", name: "account", type: "address" },
        ],
        name: "revokeRole",
        outputs: [],
        stateMutability: "nonpayable",
        type: "function",
    },
    {
        inputs: [],
        name: "sellerServiceFee",
        outputs: [{ internalType: "uint8", name: "", type: "uint8" }],
        stateMutability: "view",
        type: "function",
    },
    {
        inputs: [
            { internalType: "address", name: "newAdmin1", type: "address" },
        ],
        name: "setAdmin1",
        outputs: [{ internalType: "bool", name: "", type: "bool" }],
        stateMutability: "nonpayable",
        type: "function",
    },
    {
        inputs: [
            { internalType: "address", name: "newAdmin2", type: "address" },
        ],
        name: "setAdmin2",
        outputs: [{ internalType: "bool", name: "", type: "bool" }],
        stateMutability: "nonpayable",
        type: "function",
    },
    {
        inputs: [{ internalType: "uint8", name: "_buyerFee", type: "uint8" }],
        name: "setBuyerServiceFee",
        outputs: [{ internalType: "bool", name: "", type: "bool" }],
        stateMutability: "nonpayable",
        type: "function",
    },
    {
        inputs: [{ internalType: "uint8", name: "_partnerFee", type: "uint8" }],
        name: "setPartnerFee",
        outputs: [{ internalType: "bool", name: "", type: "bool" }],
        stateMutability: "nonpayable",
        type: "function",
    },
    {
        inputs: [{ internalType: "uint8", name: "_sellerFee", type: "uint8" }],
        name: "setSellerServiceFee",
        outputs: [{ internalType: "bool", name: "", type: "bool" }],
        stateMutability: "nonpayable",
        type: "function",
    },
    {
        inputs: [
            { internalType: "bytes4", name: "interfaceId", type: "bytes4" },
        ],
        name: "supportsInterface",
        outputs: [{ internalType: "bool", name: "", type: "bool" }],
        stateMutability: "view",
        type: "function",
    },
    {
        inputs: [
            { internalType: "address", name: "newOwner", type: "address" },
        ],
        name: "transferOwnership",
        outputs: [{ internalType: "bool", name: "", type: "bool" }],
        stateMutability: "nonpayable",
        type: "function",
    },
    {
        inputs: [],
        name: "transferProxy",
        outputs: [
            {
                internalType: "contract ITransferProxy",
                name: "",
                type: "address",
            },
        ],
        stateMutability: "view",
        type: "function",
    },
];

const Erc_abi = [
    {
        inputs: [],
        stateMutability: "nonpayable",
        type: "constructor",
    },
    {
        anonymous: false,
        inputs: [
            {
                indexed: true,
                internalType: "address",
                name: "owner",
                type: "address",
            },
            {
                indexed: true,
                internalType: "address",
                name: "spender",
                type: "address",
            },
            {
                indexed: false,
                internalType: "uint256",
                name: "value",
                type: "uint256",
            },
        ],
        name: "Approval",
        type: "event",
    },
    {
        anonymous: false,
        inputs: [
            {
                indexed: true,
                internalType: "address",
                name: "previousOwner",
                type: "address",
            },
            {
                indexed: true,
                internalType: "address",
                name: "newOwner",
                type: "address",
            },
        ],
        name: "OwnershipTransferred",
        type: "event",
    },
    {
        anonymous: false,
        inputs: [
            {
                indexed: true,
                internalType: "address",
                name: "from",
                type: "address",
            },
            {
                indexed: true,
                internalType: "address",
                name: "to",
                type: "address",
            },
            {
                indexed: false,
                internalType: "uint256",
                name: "value",
                type: "uint256",
            },
        ],
        name: "Transfer",
        type: "event",
    },
    {
        inputs: [
            {
                internalType: "address",
                name: "owner",
                type: "address",
            },
            {
                internalType: "address",
                name: "spender",
                type: "address",
            },
        ],
        name: "allowance",
        outputs: [
            {
                internalType: "uint256",
                name: "",
                type: "uint256",
            },
        ],
        stateMutability: "view",
        type: "function",
    },
    {
        inputs: [
            {
                internalType: "address",
                name: "spender",
                type: "address",
            },
            {
                internalType: "uint256",
                name: "amount",
                type: "uint256",
            },
        ],
        name: "approve",
        outputs: [
            {
                internalType: "bool",
                name: "",
                type: "bool",
            },
        ],
        stateMutability: "nonpayable",
        type: "function",
    },
    {
        inputs: [
            {
                internalType: "address",
                name: "account",
                type: "address",
            },
        ],
        name: "balanceOf",
        outputs: [
            {
                internalType: "uint256",
                name: "",
                type: "uint256",
            },
        ],
        stateMutability: "view",
        type: "function",
    },
    {
        inputs: [],
        name: "decimals",
        outputs: [
            {
                internalType: "uint8",
                name: "",
                type: "uint8",
            },
        ],
        stateMutability: "view",
        type: "function",
    },
    {
        inputs: [
            {
                internalType: "address",
                name: "spender",
                type: "address",
            },
            {
                internalType: "uint256",
                name: "subtractedValue",
                type: "uint256",
            },
        ],
        name: "decreaseAllowance",
        outputs: [
            {
                internalType: "bool",
                name: "",
                type: "bool",
            },
        ],
        stateMutability: "nonpayable",
        type: "function",
    },
    {
        inputs: [
            {
                internalType: "address",
                name: "spender",
                type: "address",
            },
            {
                internalType: "uint256",
                name: "addedValue",
                type: "uint256",
            },
        ],
        name: "increaseAllowance",
        outputs: [
            {
                internalType: "bool",
                name: "",
                type: "bool",
            },
        ],
        stateMutability: "nonpayable",
        type: "function",
    },
    {
        inputs: [
            {
                internalType: "address",
                name: "to",
                type: "address",
            },
            {
                internalType: "uint256",
                name: "amount",
                type: "uint256",
            },
        ],
        name: "mint",
        outputs: [],
        stateMutability: "nonpayable",
        type: "function",
    },
    {
        inputs: [],
        name: "name",
        outputs: [
            {
                internalType: "string",
                name: "",
                type: "string",
            },
        ],
        stateMutability: "view",
        type: "function",
    },
    {
        inputs: [],
        name: "owner",
        outputs: [
            {
                internalType: "address",
                name: "",
                type: "address",
            },
        ],
        stateMutability: "view",
        type: "function",
    },
    {
        inputs: [],
        name: "renounceOwnership",
        outputs: [],
        stateMutability: "nonpayable",
        type: "function",
    },
    {
        inputs: [],
        name: "symbol",
        outputs: [
            {
                internalType: "string",
                name: "",
                type: "string",
            },
        ],
        stateMutability: "view",
        type: "function",
    },
    {
        inputs: [],
        name: "totalSupply",
        outputs: [
            {
                internalType: "uint256",
                name: "",
                type: "uint256",
            },
        ],
        stateMutability: "view",
        type: "function",
    },
    {
        inputs: [
            {
                internalType: "address",
                name: "to",
                type: "address",
            },
            {
                internalType: "uint256",
                name: "amount",
                type: "uint256",
            },
        ],
        name: "transfer",
        outputs: [
            {
                internalType: "bool",
                name: "",
                type: "bool",
            },
        ],
        stateMutability: "nonpayable",
        type: "function",
    },
    {
        inputs: [
            {
                internalType: "address",
                name: "from",
                type: "address",
            },
            {
                internalType: "address",
                name: "to",
                type: "address",
            },
            {
                internalType: "uint256",
                name: "amount",
                type: "uint256",
            },
        ],
        name: "transferFrom",
        outputs: [
            {
                internalType: "bool",
                name: "",
                type: "bool",
            },
        ],
        stateMutability: "nonpayable",
        type: "function",
    },
    {
        inputs: [
            {
                internalType: "address",
                name: "newOwner",
                type: "address",
            },
        ],
        name: "transferOwnership",
        outputs: [],
        stateMutability: "nonpayable",
        type: "function",
    },
];

const NFT_ABI = [
    {
        inputs: [
            { internalType: "string", name: "_tokenName", type: "string" },
            { internalType: "string", name: "_tokenSymbol", type: "string" },
            { internalType: "string", name: "_baseTokenURI", type: "string" },
            { internalType: "address", name: "_signer", type: "address" },
        ],
        stateMutability: "nonpayable",
        type: "constructor",
    },
    {
        anonymous: false,
        inputs: [
            {
                indexed: true,
                internalType: "address",
                name: "account",
                type: "address",
            },
            {
                indexed: true,
                internalType: "address",
                name: "operator",
                type: "address",
            },
            {
                indexed: false,
                internalType: "bool",
                name: "approved",
                type: "bool",
            },
        ],
        name: "ApprovalForAll",
        type: "event",
    },
    {
        anonymous: false,
        inputs: [
            {
                indexed: true,
                internalType: "string",
                name: "uri",
                type: "string",
            },
            {
                indexed: true,
                internalType: "string",
                name: "newuri",
                type: "string",
            },
        ],
        name: "BaseURIChanged",
        type: "event",
    },
    {
        anonymous: false,
        inputs: [
            {
                indexed: true,
                internalType: "address",
                name: "previousOwner",
                type: "address",
            },
            {
                indexed: true,
                internalType: "address",
                name: "newOwner",
                type: "address",
            },
        ],
        name: "OwnershipTransferred",
        type: "event",
    },
    {
        anonymous: false,
        inputs: [
            {
                indexed: true,
                internalType: "bytes32",
                name: "role",
                type: "bytes32",
            },
            {
                indexed: true,
                internalType: "bytes32",
                name: "previousAdminRole",
                type: "bytes32",
            },
            {
                indexed: true,
                internalType: "bytes32",
                name: "newAdminRole",
                type: "bytes32",
            },
        ],
        name: "RoleAdminChanged",
        type: "event",
    },
    {
        anonymous: false,
        inputs: [
            {
                indexed: true,
                internalType: "bytes32",
                name: "role",
                type: "bytes32",
            },
            {
                indexed: true,
                internalType: "address",
                name: "account",
                type: "address",
            },
            {
                indexed: true,
                internalType: "address",
                name: "sender",
                type: "address",
            },
        ],
        name: "RoleGranted",
        type: "event",
    },
    {
        anonymous: false,
        inputs: [
            {
                indexed: true,
                internalType: "bytes32",
                name: "role",
                type: "bytes32",
            },
            {
                indexed: true,
                internalType: "address",
                name: "account",
                type: "address",
            },
            {
                indexed: true,
                internalType: "address",
                name: "sender",
                type: "address",
            },
        ],
        name: "RoleRevoked",
        type: "event",
    },
    {
        anonymous: false,
        inputs: [
            {
                indexed: true,
                internalType: "address",
                name: "previousSigner",
                type: "address",
            },
            {
                indexed: true,
                internalType: "address",
                name: "newSigner",
                type: "address",
            },
        ],
        name: "SignerChanged",
        type: "event",
    },
    {
        anonymous: false,
        inputs: [
            {
                indexed: true,
                internalType: "address",
                name: "operator",
                type: "address",
            },
            {
                indexed: true,
                internalType: "address",
                name: "from",
                type: "address",
            },
            {
                indexed: true,
                internalType: "address",
                name: "to",
                type: "address",
            },
            {
                indexed: false,
                internalType: "uint256[]",
                name: "ids",
                type: "uint256[]",
            },
            {
                indexed: false,
                internalType: "uint256[]",
                name: "values",
                type: "uint256[]",
            },
        ],
        name: "TransferBatch",
        type: "event",
    },
    {
        anonymous: false,
        inputs: [
            {
                indexed: true,
                internalType: "address",
                name: "operator",
                type: "address",
            },
            {
                indexed: true,
                internalType: "address",
                name: "from",
                type: "address",
            },
            {
                indexed: true,
                internalType: "address",
                name: "to",
                type: "address",
            },
            {
                indexed: false,
                internalType: "uint256",
                name: "id",
                type: "uint256",
            },
            {
                indexed: false,
                internalType: "uint256",
                name: "value",
                type: "uint256",
            },
        ],
        name: "TransferSingle",
        type: "event",
    },
    {
        anonymous: false,
        inputs: [
            {
                indexed: false,
                internalType: "string",
                name: "value",
                type: "string",
            },
            {
                indexed: true,
                internalType: "uint256",
                name: "id",
                type: "uint256",
            },
        ],
        name: "URI",
        type: "event",
    },
    {
        inputs: [],
        name: "DEFAULT_ADMIN_ROLE",
        outputs: [{ internalType: "bytes32", name: "", type: "bytes32" }],
        stateMutability: "view",
        type: "function",
    },
    {
        inputs: [
            { internalType: "address", name: "account", type: "address" },
            { internalType: "uint256", name: "id", type: "uint256" },
        ],
        name: "balanceOf",
        outputs: [{ internalType: "uint256", name: "", type: "uint256" }],
        stateMutability: "view",
        type: "function",
    },
    {
        inputs: [
            { internalType: "address[]", name: "accounts", type: "address[]" },
            { internalType: "uint256[]", name: "ids", type: "uint256[]" },
        ],
        name: "balanceOfBatch",
        outputs: [{ internalType: "uint256[]", name: "", type: "uint256[]" }],
        stateMutability: "view",
        type: "function",
    },
    {
        inputs: [
            { internalType: "address", name: "account", type: "address" },
            { internalType: "uint256", name: "id", type: "uint256" },
            { internalType: "uint256", name: "value", type: "uint256" },
        ],
        name: "burn",
        outputs: [],
        stateMutability: "nonpayable",
        type: "function",
    },
    {
        inputs: [
            { internalType: "address", name: "account", type: "address" },
            { internalType: "uint256[]", name: "ids", type: "uint256[]" },
            { internalType: "uint256[]", name: "values", type: "uint256[]" },
        ],
        name: "burnBatch",
        outputs: [],
        stateMutability: "nonpayable",
        type: "function",
    },
    {
        inputs: [
            { internalType: "address", name: "newSigner", type: "address" },
        ],
        name: "changeSigner",
        outputs: [{ internalType: "bool", name: "", type: "bool" }],
        stateMutability: "nonpayable",
        type: "function",
    },
    {
        inputs: [{ internalType: "uint256", name: "id", type: "uint256" }],
        name: "exists",
        outputs: [{ internalType: "bool", name: "", type: "bool" }],
        stateMutability: "view",
        type: "function",
    },
    {
        inputs: [{ internalType: "bytes32", name: "role", type: "bytes32" }],
        name: "getRoleAdmin",
        outputs: [{ internalType: "bytes32", name: "", type: "bytes32" }],
        stateMutability: "view",
        type: "function",
    },
    {
        inputs: [
            { internalType: "bytes32", name: "role", type: "bytes32" },
            { internalType: "address", name: "account", type: "address" },
        ],
        name: "grantRole",
        outputs: [],
        stateMutability: "nonpayable",
        type: "function",
    },
    {
        inputs: [
            { internalType: "bytes32", name: "role", type: "bytes32" },
            { internalType: "address", name: "account", type: "address" },
        ],
        name: "hasRole",
        outputs: [{ internalType: "bool", name: "", type: "bool" }],
        stateMutability: "view",
        type: "function",
    },
    {
        inputs: [
            { internalType: "address", name: "account", type: "address" },
            { internalType: "address", name: "operator", type: "address" },
        ],
        name: "isApprovedForAll",
        outputs: [{ internalType: "bool", name: "", type: "bool" }],
        stateMutability: "view",
        type: "function",
    },
    {
        inputs: [
            { internalType: "string", name: "_tokenURI", type: "string" },
            { internalType: "uint96", name: "_royaltyFee", type: "uint96" },
            { internalType: "uint256", name: "supply", type: "uint256" },
            {
                components: [
                    { internalType: "uint8", name: "v", type: "uint8" },
                    { internalType: "bytes32", name: "r", type: "bytes32" },
                    { internalType: "bytes32", name: "s", type: "bytes32" },
                    { internalType: "uint256", name: "nonce", type: "uint256" },
                ],
                internalType: "struct NFTTC_ERC1155_Contract.Sign",
                name: "sign",
                type: "tuple",
            },
        ],
        name: "mint",
        outputs: [
            { internalType: "uint256", name: "_tokenId", type: "uint256" },
        ],
        stateMutability: "nonpayable",
        type: "function",
    },
    {
        inputs: [],
        name: "name",
        outputs: [{ internalType: "string", name: "", type: "string" }],
        stateMutability: "view",
        type: "function",
    },
    {
        inputs: [],
        name: "owner",
        outputs: [{ internalType: "address", name: "", type: "address" }],
        stateMutability: "view",
        type: "function",
    },
    {
        inputs: [
            { internalType: "bytes32", name: "role", type: "bytes32" },
            { internalType: "address", name: "account", type: "address" },
        ],
        name: "renounceRole",
        outputs: [],
        stateMutability: "nonpayable",
        type: "function",
    },
    {
        inputs: [
            { internalType: "bytes32", name: "role", type: "bytes32" },
            { internalType: "address", name: "account", type: "address" },
        ],
        name: "revokeRole",
        outputs: [],
        stateMutability: "nonpayable",
        type: "function",
    },
    {
        inputs: [
            { internalType: "uint256", name: "_tokenId", type: "uint256" },
            { internalType: "uint256", name: "_salePrice", type: "uint256" },
        ],
        name: "royaltyInfo",
        outputs: [
            { internalType: "address", name: "", type: "address" },
            { internalType: "uint256", name: "", type: "uint256" },
        ],
        stateMutability: "view",
        type: "function",
    },
    {
        inputs: [
            { internalType: "address", name: "from", type: "address" },
            { internalType: "address", name: "to", type: "address" },
            { internalType: "uint256[]", name: "ids", type: "uint256[]" },
            { internalType: "uint256[]", name: "amounts", type: "uint256[]" },
            { internalType: "bytes", name: "data", type: "bytes" },
        ],
        name: "safeBatchTransferFrom",
        outputs: [],
        stateMutability: "nonpayable",
        type: "function",
    },
    {
        inputs: [
            { internalType: "address", name: "from", type: "address" },
            { internalType: "address", name: "to", type: "address" },
            { internalType: "uint256", name: "id", type: "uint256" },
            { internalType: "uint256", name: "amount", type: "uint256" },
            { internalType: "bytes", name: "data", type: "bytes" },
        ],
        name: "safeTransferFrom",
        outputs: [],
        stateMutability: "nonpayable",
        type: "function",
    },
    {
        inputs: [
            { internalType: "address", name: "operator", type: "address" },
            { internalType: "bool", name: "approved", type: "bool" },
        ],
        name: "setApprovalForAll",
        outputs: [],
        stateMutability: "nonpayable",
        type: "function",
    },
    {
        inputs: [{ internalType: "string", name: "uri_", type: "string" }],
        name: "setBaseURI",
        outputs: [{ internalType: "bool", name: "", type: "bool" }],
        stateMutability: "nonpayable",
        type: "function",
    },
    {
        inputs: [],
        name: "signer",
        outputs: [{ internalType: "address", name: "", type: "address" }],
        stateMutability: "view",
        type: "function",
    },
    {
        inputs: [
            { internalType: "bytes4", name: "interfaceId", type: "bytes4" },
        ],
        name: "supportsInterface",
        outputs: [{ internalType: "bool", name: "", type: "bool" }],
        stateMutability: "view",
        type: "function",
    },
    {
        inputs: [],
        name: "symbol",
        outputs: [{ internalType: "string", name: "", type: "string" }],
        stateMutability: "view",
        type: "function",
    },
    {
        inputs: [{ internalType: "uint256", name: "id", type: "uint256" }],
        name: "totalSupply",
        outputs: [{ internalType: "uint256", name: "", type: "uint256" }],
        stateMutability: "view",
        type: "function",
    },
    {
        inputs: [
            { internalType: "address", name: "newOwner", type: "address" },
        ],
        name: "transferOwnership",
        outputs: [{ internalType: "bool", name: "", type: "bool" }],
        stateMutability: "nonpayable",
        type: "function",
    },
    {
        inputs: [{ internalType: "uint256", name: "tokenId", type: "uint256" }],
        name: "uri",
        outputs: [{ internalType: "string", name: "", type: "string" }],
        stateMutability: "view",
        type: "function",
    },
];

const Own_abi = [
    {
        inputs: [
            {
                internalType: "string",
                name: "_tokenName",
                type: "string",
            },
            {
                internalType: "string",
                name: "_tokenSymbol",
                type: "string",
            },
            {
                internalType: "string",
                name: "_baseTokenURI",
                type: "string",
            },
        ],
        stateMutability: "nonpayable",
        type: "constructor",
    },
    {
        anonymous: false,
        inputs: [
            {
                indexed: true,
                internalType: "address",
                name: "account",
                type: "address",
            },
            {
                indexed: true,
                internalType: "address",
                name: "operator",
                type: "address",
            },
            {
                indexed: false,
                internalType: "bool",
                name: "approved",
                type: "bool",
            },
        ],
        name: "ApprovalForAll",
        type: "event",
    },
    {
        anonymous: false,
        inputs: [
            {
                indexed: true,
                internalType: "string",
                name: "uri",
                type: "string",
            },
            {
                indexed: true,
                internalType: "string",
                name: "newuri",
                type: "string",
            },
        ],
        name: "BaseURIChanged",
        type: "event",
    },
    {
        anonymous: false,
        inputs: [
            {
                indexed: true,
                internalType: "address",
                name: "previousOwner",
                type: "address",
            },
            {
                indexed: true,
                internalType: "address",
                name: "newOwner",
                type: "address",
            },
        ],
        name: "OwnershipTransferred",
        type: "event",
    },
    {
        anonymous: false,
        inputs: [
            {
                indexed: true,
                internalType: "bytes32",
                name: "role",
                type: "bytes32",
            },
            {
                indexed: true,
                internalType: "bytes32",
                name: "previousAdminRole",
                type: "bytes32",
            },
            {
                indexed: true,
                internalType: "bytes32",
                name: "newAdminRole",
                type: "bytes32",
            },
        ],
        name: "RoleAdminChanged",
        type: "event",
    },
    {
        anonymous: false,
        inputs: [
            {
                indexed: true,
                internalType: "bytes32",
                name: "role",
                type: "bytes32",
            },
            {
                indexed: true,
                internalType: "address",
                name: "account",
                type: "address",
            },
            {
                indexed: true,
                internalType: "address",
                name: "sender",
                type: "address",
            },
        ],
        name: "RoleGranted",
        type: "event",
    },
    {
        anonymous: false,
        inputs: [
            {
                indexed: true,
                internalType: "bytes32",
                name: "role",
                type: "bytes32",
            },
            {
                indexed: true,
                internalType: "address",
                name: "account",
                type: "address",
            },
            {
                indexed: true,
                internalType: "address",
                name: "sender",
                type: "address",
            },
        ],
        name: "RoleRevoked",
        type: "event",
    },
    {
        anonymous: false,
        inputs: [
            {
                indexed: true,
                internalType: "address",
                name: "operator",
                type: "address",
            },
            {
                indexed: true,
                internalType: "address",
                name: "from",
                type: "address",
            },
            {
                indexed: true,
                internalType: "address",
                name: "to",
                type: "address",
            },
            {
                indexed: false,
                internalType: "uint256[]",
                name: "ids",
                type: "uint256[]",
            },
            {
                indexed: false,
                internalType: "uint256[]",
                name: "values",
                type: "uint256[]",
            },
        ],
        name: "TransferBatch",
        type: "event",
    },
    {
        anonymous: false,
        inputs: [
            {
                indexed: true,
                internalType: "address",
                name: "operator",
                type: "address",
            },
            {
                indexed: true,
                internalType: "address",
                name: "from",
                type: "address",
            },
            {
                indexed: true,
                internalType: "address",
                name: "to",
                type: "address",
            },
            {
                indexed: false,
                internalType: "uint256",
                name: "id",
                type: "uint256",
            },
            {
                indexed: false,
                internalType: "uint256",
                name: "value",
                type: "uint256",
            },
        ],
        name: "TransferSingle",
        type: "event",
    },
    {
        anonymous: false,
        inputs: [
            {
                indexed: false,
                internalType: "string",
                name: "value",
                type: "string",
            },
            {
                indexed: true,
                internalType: "uint256",
                name: "id",
                type: "uint256",
            },
        ],
        name: "URI",
        type: "event",
    },
    {
        inputs: [],
        name: "DEFAULT_ADMIN_ROLE",
        outputs: [
            {
                internalType: "bytes32",
                name: "",
                type: "bytes32",
            },
        ],
        stateMutability: "view",
        type: "function",
    },
    {
        inputs: [
            {
                internalType: "address",
                name: "account",
                type: "address",
            },
            {
                internalType: "uint256",
                name: "id",
                type: "uint256",
            },
        ],
        name: "balanceOf",
        outputs: [
            {
                internalType: "uint256",
                name: "",
                type: "uint256",
            },
        ],
        stateMutability: "view",
        type: "function",
    },
    {
        inputs: [
            {
                internalType: "address[]",
                name: "accounts",
                type: "address[]",
            },
            {
                internalType: "uint256[]",
                name: "ids",
                type: "uint256[]",
            },
        ],
        name: "balanceOfBatch",
        outputs: [
            {
                internalType: "uint256[]",
                name: "",
                type: "uint256[]",
            },
        ],
        stateMutability: "view",
        type: "function",
    },
    {
        inputs: [
            {
                internalType: "address",
                name: "account",
                type: "address",
            },
            {
                internalType: "uint256",
                name: "id",
                type: "uint256",
            },
            {
                internalType: "uint256",
                name: "value",
                type: "uint256",
            },
        ],
        name: "burn",
        outputs: [],
        stateMutability: "nonpayable",
        type: "function",
    },
    {
        inputs: [
            {
                internalType: "address",
                name: "account",
                type: "address",
            },
            {
                internalType: "uint256[]",
                name: "ids",
                type: "uint256[]",
            },
            {
                internalType: "uint256[]",
                name: "values",
                type: "uint256[]",
            },
        ],
        name: "burnBatch",
        outputs: [],
        stateMutability: "nonpayable",
        type: "function",
    },
    {
        inputs: [
            {
                internalType: "uint256",
                name: "id",
                type: "uint256",
            },
        ],
        name: "exists",
        outputs: [
            {
                internalType: "bool",
                name: "",
                type: "bool",
            },
        ],
        stateMutability: "view",
        type: "function",
    },
    {
        inputs: [
            {
                internalType: "bytes32",
                name: "role",
                type: "bytes32",
            },
        ],
        name: "getRoleAdmin",
        outputs: [
            {
                internalType: "bytes32",
                name: "",
                type: "bytes32",
            },
        ],
        stateMutability: "view",
        type: "function",
    },
    {
        inputs: [
            {
                internalType: "bytes32",
                name: "role",
                type: "bytes32",
            },
            {
                internalType: "address",
                name: "account",
                type: "address",
            },
        ],
        name: "grantRole",
        outputs: [],
        stateMutability: "nonpayable",
        type: "function",
    },
    {
        inputs: [
            {
                internalType: "bytes32",
                name: "role",
                type: "bytes32",
            },
            {
                internalType: "address",
                name: "account",
                type: "address",
            },
        ],
        name: "hasRole",
        outputs: [
            {
                internalType: "bool",
                name: "",
                type: "bool",
            },
        ],
        stateMutability: "view",
        type: "function",
    },
    {
        inputs: [
            {
                internalType: "address",
                name: "account",
                type: "address",
            },
            {
                internalType: "address",
                name: "operator",
                type: "address",
            },
        ],
        name: "isApprovedForAll",
        outputs: [
            {
                internalType: "bool",
                name: "",
                type: "bool",
            },
        ],
        stateMutability: "view",
        type: "function",
    },
    {
        inputs: [
            {
                internalType: "string",
                name: "_tokenURI",
                type: "string",
            },
            {
                internalType: "uint96",
                name: "_royaltyFee",
                type: "uint96",
            },
            {
                internalType: "uint256",
                name: "supply",
                type: "uint256",
            },
        ],
        name: "mint",
        outputs: [
            {
                internalType: "uint256",
                name: "_tokenId",
                type: "uint256",
            },
        ],
        stateMutability: "nonpayable",
        type: "function",
    },
    {
        inputs: [],
        name: "name",
        outputs: [
            {
                internalType: "string",
                name: "",
                type: "string",
            },
        ],
        stateMutability: "view",
        type: "function",
    },
    {
        inputs: [],
        name: "owner",
        outputs: [
            {
                internalType: "address",
                name: "",
                type: "address",
            },
        ],
        stateMutability: "view",
        type: "function",
    },
    {
        inputs: [
            {
                internalType: "bytes32",
                name: "role",
                type: "bytes32",
            },
            {
                internalType: "address",
                name: "account",
                type: "address",
            },
        ],
        name: "renounceRole",
        outputs: [],
        stateMutability: "nonpayable",
        type: "function",
    },
    {
        inputs: [
            {
                internalType: "bytes32",
                name: "role",
                type: "bytes32",
            },
            {
                internalType: "address",
                name: "account",
                type: "address",
            },
        ],
        name: "revokeRole",
        outputs: [],
        stateMutability: "nonpayable",
        type: "function",
    },
    {
        inputs: [
            {
                internalType: "uint256",
                name: "_tokenId",
                type: "uint256",
            },
            {
                internalType: "uint256",
                name: "_salePrice",
                type: "uint256",
            },
        ],
        name: "royaltyInfo",
        outputs: [
            {
                internalType: "address",
                name: "",
                type: "address",
            },
            {
                internalType: "uint256",
                name: "",
                type: "uint256",
            },
        ],
        stateMutability: "view",
        type: "function",
    },
    {
        inputs: [
            {
                internalType: "address",
                name: "from",
                type: "address",
            },
            {
                internalType: "address",
                name: "to",
                type: "address",
            },
            {
                internalType: "uint256[]",
                name: "ids",
                type: "uint256[]",
            },
            {
                internalType: "uint256[]",
                name: "amounts",
                type: "uint256[]",
            },
            {
                internalType: "bytes",
                name: "data",
                type: "bytes",
            },
        ],
        name: "safeBatchTransferFrom",
        outputs: [],
        stateMutability: "nonpayable",
        type: "function",
    },
    {
        inputs: [
            {
                internalType: "address",
                name: "from",
                type: "address",
            },
            {
                internalType: "address",
                name: "to",
                type: "address",
            },
            {
                internalType: "uint256",
                name: "id",
                type: "uint256",
            },
            {
                internalType: "uint256",
                name: "amount",
                type: "uint256",
            },
            {
                internalType: "bytes",
                name: "data",
                type: "bytes",
            },
        ],
        name: "safeTransferFrom",
        outputs: [],
        stateMutability: "nonpayable",
        type: "function",
    },
    {
        inputs: [
            {
                internalType: "address",
                name: "operator",
                type: "address",
            },
            {
                internalType: "bool",
                name: "approved",
                type: "bool",
            },
        ],
        name: "setApprovalForAll",
        outputs: [],
        stateMutability: "nonpayable",
        type: "function",
    },
    {
        inputs: [
            {
                internalType: "string",
                name: "uri_",
                type: "string",
            },
        ],
        name: "setBaseURI",
        outputs: [
            {
                internalType: "bool",
                name: "",
                type: "bool",
            },
        ],
        stateMutability: "nonpayable",
        type: "function",
    },
    {
        inputs: [
            {
                internalType: "bytes4",
                name: "interfaceId",
                type: "bytes4",
            },
        ],
        name: "supportsInterface",
        outputs: [
            {
                internalType: "bool",
                name: "",
                type: "bool",
            },
        ],
        stateMutability: "view",
        type: "function",
    },
    {
        inputs: [],
        name: "symbol",
        outputs: [
            {
                internalType: "string",
                name: "",
                type: "string",
            },
        ],
        stateMutability: "view",
        type: "function",
    },
    {
        inputs: [
            {
                internalType: "uint256",
                name: "id",
                type: "uint256",
            },
        ],
        name: "totalSupply",
        outputs: [
            {
                internalType: "uint256",
                name: "",
                type: "uint256",
            },
        ],
        stateMutability: "view",
        type: "function",
    },
    {
        inputs: [
            {
                internalType: "address",
                name: "newOwner",
                type: "address",
            },
        ],
        name: "transferOwnership",
        outputs: [
            {
                internalType: "bool",
                name: "",
                type: "bool",
            },
        ],
        stateMutability: "nonpayable",
        type: "function",
    },
    {
        inputs: [
            {
                internalType: "uint256",
                name: "tokenId",
                type: "uint256",
            },
        ],
        name: "uri",
        outputs: [
            {
                internalType: "string",
                name: "",
                type: "string",
            },
        ],
        stateMutability: "view",
        type: "function",
    },
];

const Trading_contract = "0x0e1F24eEE3e5dd298d3BC94b5cFa0336cF8E8750"; //"0x555370a16417350DC74F7CaC6831738eCCB650F5";
const NFT_address = "0xf8E947AC48377D4C2fF7747608596fEA1311551c";
const ERC_address = "0xDeF80470E6F4adA5Fa647dA9b38b2eEd0f3CF4B1";
const Proxy_address = "0x26C84BA2de2e1C79A48B17ed6c6e0e2D3340b97c";

const Trading = new ethers.Contract(Trading_contract, Trade_abi, provider);
const NftConfig = new ethers.Contract(NFT_address, NFT_ABI, provider);

async function sellerapprove(address, collection) {
    var signer = await provider.getSigner();
    if (collection == undefined) {
        var sellertokenContract = NftConfig.connect(signer);
    } else {
        const own_instance = new ethers.Contract(collection, Own_abi, provider);
        var sellertokenContract = own_instance.connect(signer);
    }

    var approve = await sellertokenContract
        .setApprovalForAll(address, true)
        .then(async (txn) => {
            console.log(txn);
            await txn.wait();
            return true;
        })
        .catch((error) => {
            return false;
        });
    return approve;
}

async function checkbalance(address, token_id) {
    var balance = await NftConfig.balanceOf(address, token_id)
        .then(async (trx) => {
            var balance_of = parseInt(trx._hex);
            return balance_of;
        })
        .catch((err) => {
            console.log(err);
        });
    return balance;
}

async function check_own_balance(contract, address, token_id) {
    const own_instance = new ethers.Contract(contract, Own_abi, provider);
    var balance = await own_instance
        .balanceOf(address, token_id)
        .then(async (trx) => {
            var balance_of = parseInt(trx._hex);
            console.log("getting balance");
            console.log("balanceOf", balance_of);
            return balance_of;
        })
        .catch((err) => {
            console.log(err);
        });
    return balance;
}

$("#EnableBid").submit(async function (e) {
    $("#preloader").show();
    e.preventDefault();

    var user_address = $(".UserAddress").val();
    if (user_address == "") {
        $("#preloader").hide();
        toastify("Kindly connect your wallet", "error");
        setTimeout(() => {
            location.reload();
        }, 2000);
    }

    var token = $("#csrf_token").val();
    var card_quantity = $("#CardQuantityBid").val();
    var card_price = $("#CardPriceBid").val();
    var saletype = $("#SaleTypeBid").val();
    var end_at = $("#EndAtBid").val();
    var cardId = $("#CardIdBid").val();
    var token_id = $("#TokenIdBid").val();
    var own_contract = $("#BidCollectionId").val();

    if (own_contract == undefined) {
        var checkBalance = await checkbalance(user_address, token_id);
    } else {
        var checkBalance = await check_own_balance(
            own_contract,
            user_address,
            token_id
        );
    }
    console.log(card_quantity, checkBalance);
    if (checkBalance < card_quantity) {
        $("#preloader").hide();
        toastify("You not have sufficiant NFT", "error");
        setTimeout(() => {
            location.reload();
        }, 2000);
        return false;
    }

    var amount = card_price * 10 ** 18;
    var amount = amount.toString();
    var sellerApprove = await sellerapprove(Proxy_address, own_contract);
    if (sellerApprove != false) {
        var sign = await SellerSign(token_id, card_price, amount, own_contract);
        var VRS = sign.sign_vrs;
        $.ajax({
            url: "/bidding",
            method: "POST",
            headers: {
                "X-CSRF-Token": token,
            },
            data: {
                quantity: card_quantity,
                price: card_price,
                type: saletype,
                end_at: end_at,
                card_id: cardId,
                collection: own_contract,
                VRS,
            },
        }).done(function (response) {
            if (response.status == "success") {
                $("#preloader").hide();
                toastify("Sale Listed for Bid Successfully", "success");
                setTimeout(() => {
                    location.reload();
                }, 2000);
            } else {
                $("#preloader").hide();
                toastify(response.status, "error");
                setTimeout(() => {
                    location.reload();
                }, 2000);
            }
        });
    } else {
        $("#preloader").hide();
        toastify("Something went wrong in NFT approval", "error");
    }
});

$("#StartBidding").on("submit", async function (e) {
    try {
        $("#preloader").show();
        e.preventDefault();
        var sale_id = $("#BiddingCard").val();
        var seller_address = $("#BidBuySellerAddress").val();
        var partner_address = $("#BidPartnerAddress").val();
        var bid_amount = $("#BidAmount").val();
        var bid_quantity = $("#BidQuantity").val();
        var token_id = $("#BidTokenId").val();
        var collection_type = $("#BidCollection").val();
        var signer = await provider.getSigner();

        var buyerfee = await Buyerfees();
        if (partner_address != "no partner") {
            var partnerfee = await Partnerfees();
        } else {
            var partnerfee = 0;
        }

        var sellerfee = await Sellerfees();

        var totalfee = buyerfee + partnerfee + sellerfee;
        console.log(buyerfee, partnerfee, sellerfee, totalfee);

        var fees = ((bid_amount * totalfee) / 100).toFixed(5);
        var fullamount = parseFloat(bid_amount) + parseFloat(fees);
        var amount = ethers.utils.parseEther(fullamount.toString());
        console.log(amount);
        var approve = await stableapprove(amount, signer, Proxy_address);
        if (approve == false) {
            $("#preloader").hide();
            toastify("Stable approve failed", "error");
            setTimeout(() => {
                location.reload();
            }, 2000);
        }
        var sign = await BuyerBidSign(
            token_id,
            amount,
            bid_quantity,
            collection_type
        )
            .then(async (trx) => {
                console.log(trx);
                var VRS = trx.sign_vrs;
                $.ajax({
                    url: "/create-bidding",
                    method: "POST",
                    headers: {
                        "X-CSRF-Token": token,
                    },
                    data: {
                        quantity: bid_quantity,
                        sale_id: sale_id,
                        amount: bid_amount,
                        VRS,
                    },
                }).done(function (response) {
                    if (response.status == "success") {
                        $("#preloader").hide();
                        toastify("Bidding Created Successfully", "success");
                        setTimeout(() => {
                            location.reload();
                        }, 2000);
                    } else {
                        $("#preloader").hide();
                        toastify(response.status, "error");
                        console.log(response.message);
                        setTimeout(() => {
                            location.reload();
                        }, 2000);
                    }
                });
            })
            .catch((err) => {
                console.log(err);
            });
    } catch (err) {
        console.log(err);
    }
});

async function UpdateBidding(id) {
    $("#preloader").show();
    $.ajax({
        url: "/find-bid",
        method: "POST",
        data: {
            id: id,
            _token: token,
        },
    }).done(async function (response) {
        console.log(response);
        if (response.status == "success") {
            var unitprice = ethers.utils.parseEther(
                (
                    response.bid_details.amount / response.bid_details.quantity
                ).toString()
            );
            var signer = await provider.getSigner();

            var buyerfee = await Buyerfees();
            if (response.partner != "no partner") {
                var partnerfee = await Partnerfees();
                var partnerAddress = response.partner;
            } else {
                var partnerfee = 0;
                var partnerAddress = response.bid_details.sale.seller_address;
            }
            var sellerfee = await Sellerfees();

            var totalfee = buyerfee + partnerfee + sellerfee;
            console.log(buyerfee, partnerfee, sellerfee, totalfee);

            var fees = (response.bid_details.amount * totalfee) / 100;
            var bidAmount = response.bid_details.amount * 1;
            var fullamount = bidAmount + fees;
            var fullamount = fullamount.toString();
            var amount = ethers.utils.parseEther(fullamount);

            console.log(amount, unitprice);

            if (response.bid_details.sale.collection == "admin") {
                assetAddress = NFT_address;
            } else {
                assetAddress = response.bid_details.sale.collection;
            }
            var Bid_assets = [];
            Bid_assets.push(response.bid_details.sale.seller_address);
            Bid_assets.push(response.bid_details.wallet_address);
            Bid_assets.push(partnerAddress);
            Bid_assets.push(ERC_address);
            Bid_assets.push(assetAddress);
            Bid_assets.push("1");
            Bid_assets.push(unitprice);
            Bid_assets.push(amount);
            Bid_assets.push(response.token_id);
            Bid_assets.push(response.bid_details.quantity);
            console.log(Bid_assets);
            var vrs_data = JSON.parse(response.bid_details.vrs);
            console.log(vrs_data);
            var gasPrice = await provider.getGasPrice();
            var Bid = await Trading.connect(signer).executeBid(
                Bid_assets,
                vrs_data,
                {
                    gasLimit: 6000000,
                    gasPrice: gasPrice,
                }
            );
            console.log(Bid);
            const BidReceipt = await Bid.wait();
            console.log(BidReceipt);

            $.ajax({
                url: "/update-bidding",
                method: "POST",
                headers: {
                    "X-CSRF-Token": token,
                },
                data: {
                    id: id,
                    trx_hash: BidReceipt.transactionHash,
                },
            }).done(function (res) {
                if (res.status == "success") {
                    $("#preloader").hide();
                    toastify("Bidding Completed successfully", "success");
                    setTimeout(() => {
                        location.reload();
                    }, 3000);
                } else {
                    $("#preloader").hide();
                    toastify("Something went wrong in store details", "error");
                    setTimeout(() => {
                        location.reload();
                    }, 3000);
                }
            });
        } else {
            $("#preloader").hide();
            toastify("Something went wrong", "error");
            setTimeout(() => {
                location.reload();
            }, 500);
        }
    });
}

$("#EnableBuy").submit(async function (e) {
    $("#preloader").show();
    e.preventDefault();
    var user_address = $(".UserAddress").val();
    if (user_address == "") {
        $("#preloader").hide();
        toastify("Kindly connect your wallet", "error");
        setTimeout(() => {
            location.reload();
        }, 2000);
    }

    var card_quantity = $("#CardQuantity").val();
    var card_price = $("#CardPrice").val();
    var saletype = $("#SaleType").val();
    var cardId = $("#CardIdBuy").val();
    var token_id = $("#TokenId").val();
    var own_contract = $("#CollectionId").val();
    balance = card_price.toString();
    var percard_price = card_price / card_quantity;
    var amount = ethers.utils.parseEther(percard_price.toString());
    if (own_contract == undefined) {
        var checkBalance = await checkbalance(user_address, token_id);
    } else {
        var checkBalance = await check_own_balance(
            own_contract,
            user_address,
            token_id
        );
    }
    console.log(own_contract, checkBalance);
    if (checkBalance < card_quantity) {
        $("#preloader").hide();
        toastify("You not have sufficiant NFT", "error");
        setTimeout(() => {
            location.reload();
        }, 2000);
        return false;
    }
    var sellerApprove = await sellerapprove(Proxy_address, own_contract);

    var sign = await SellerSign(token_id, card_price, amount, own_contract);
    var VRS = sign.sign_vrs;
    $.ajax({
        url: "/bidding",
        method: "POST",
        headers: {
            "X-CSRF-Token": token,
        },
        data: {
            quantity: card_quantity,
            price: card_price,
            type: saletype,
            card_id: cardId,
            collection: own_contract,
            VRS,
        },
    })
        .done(function (response) {
            if (response.status == "success") {
                $("#preloader").hide();
                toastify("Sale Listed for Buy Successfully", "success");
                setTimeout(() => {
                    location.reload();
                }, 500);
            } else {
                $("#preloader").hide();
                toastify(response.status, "error");
                setTimeout(() => {
                    location.reload();
                }, 500);
            }
        })
        .catch(function (error) {
            $("#preloader").hide();
            console.log(error);
            toastify("Something went wrong", "error");
            setTimeout(() => {
                location.reload();
            }, 500);
        });
});

$("#BuyForm").submit(async function (event) {
    event.preventDefault();
    try {
        $("#preloader").show();
        var formData = $(this).serialize();
        var formDataArray = formData.split("&");

        var saleId = $("#BuySaleId").val();
        var seller = $("#SellerAddress").val();
        var buyer = $("#BuyerAddress").val();
        var partner = $("#PartnerAddress").val();
        var partnerType = $("#PartnerType").val();
        var token_id = $("#TokenId").val();
        var unitprice = $("#BuyMinPrice").val();
        var qty = $("#BuyQuantity").val();
        var vrs = $("#VRSData").val();
        var collection = $("#Collection").val();
        var vrs_data = JSON.parse(vrs);

        var percard_price = (unitprice / qty).toFixed(5);
        var total_amount = (percard_price * qty).toFixed(5);

        var buyerfee = await Buyerfees();
        if (partner != "no partner") {
            var partnerfee = await Partnerfees();
        } else {
            var partnerfee = 0;
            partner = seller;
        }

        var sellerfee = await Sellerfees();

        var totalfee = buyerfee + partnerfee + sellerfee;
        console.log(buyerfee, partnerfee, sellerfee, totalfee);
        
        var fees = (total_amount * totalfee) / 100;
        
        var fullamount = (parseFloat(total_amount) + parseFloat(fees)).toFixed(5);
        console.log(fullamount, percard_price);
        
        var unitPriceDecimal = ethers.utils.parseEther(percard_price.toString());
       

        var balance = fullamount.toString();
        
        var amount = ethers.utils.parseEther(balance);

        var signer = await provider.getSigner();
        
        var gasPrice = await provider.getGasPrice();

        if (collection == "admin") {
            var asset_Address = NFT_address;
        } else {
            var asset_Address = collection;
        }

        var BuyArray = [];
        BuyArray.push(
            seller,
            buyer,
            partner,
            ERC_address,
            asset_Address,
            partnerType,
            unitPriceDecimal,
            amount,
            token_id,
            qty
        );

        var approve = await stableapprove(amount, signer, Proxy_address);
        if (approve == false) {
            return false;
        }
        console.log("logging Array");
        console.log(BuyArray, vrs_data);
        var Buy = await Trading.connect(signer).buyAsset(BuyArray, vrs_data, {
            gasLimit: 300000,
            gasPrice: gasPrice,
            //add value here inlcudes the price plus all fees
        });
        const BuyReceipt = await Buy.wait();
        console.log(BuyReceipt);
        console.log(BuyReceipt.transactionHash);
        if (BuyReceipt == null){
            toastify("Something went wrong in store details", "error");
            return false;
        }
        $.ajax({
            url: "/buy",
            method: "POST",
            headers: {
                "X-CSRF-Token": token,
            },
            data: {
                sale_id: saleId,
                trx_hash: BuyReceipt.transactionHash,
            },
        }).done(function (response) {
            if (response.status == "success") {
                $("#preloader").hide();
                toastify("Card purchased successfully", "success");
                setTimeout(() => {
                    location.href = "/earnings";
                }, 3000);
            } else {
                $("#preloader").hide();
                toastify("Something went wrong in store details", "error");
                setTimeout(() => {
                    location.reload();
                }, 3000);
            }
        });
    } catch (error) {
        console.log(error);
        $("#preloader").hide();
        toastify("Something went wrong", "error");
        setTimeout(() => {
            location.reload();
        }, 3000);
    }
});

async function stableapprove(amount, signer, token_address) {
    console.log(amount, token_address);
    var stable_contract = new ethers.Contract(ERC_address, Erc_abi, provider);
    console.log(token_address, amount);
    var stabletokenContract = stable_contract.connect(signer);
    var approve = await stabletokenContract
        .approve(token_address, amount)
        .then(async (txn) => {
            console.log(txn);
            await txn.wait();
            return true;
        })
        .catch((error) => {
            console.log(error);
            return false;
        });
    return approve;
}

async function SellerSign(token_id, card_price, amount, collection) {
    try {
        console.log(token_id, card_price, amount, collection);
        var dat = new Date().getTime();
        var nonce = Math.floor(dat / 1000);
        var signer = await provider.getSigner();
        if (collection == undefined) {
            var assetAddress = NFT_address;
        } else {
            var assetAddress = collection;
        }
        var paymentAddress = ERC_address;
        var token_arr = [];
        token_arr.push(assetAddress);
        token_arr.push(token_id);
        token_arr.push(paymentAddress);
        token_arr.push(amount);
        token_arr.push(nonce);
        let param0 = token_arr; // rouyalty and tokenuri are null //check quantity, supply
        console.log(param0);
        let hash0 = ethers.utils.solidityKeccak256(
            ["address", "uint256", "address", "uint256", "uint256"],
            param0
        );
        console.log(hash0);
        // var getSign = await signer.signMessage("Click sign to continue Buy");
        console.log(signer);
        let sign0 = await signer.signMessage(ethers.utils.arrayify(hash0));
        let breakDown0 = await ethers.utils.splitSignature(sign0);
        let VRSN0 = [breakDown0.v, breakDown0.r, breakDown0.s, nonce];
        console.log(VRSN0);
        return { status: 1, sign_vrs: VRSN0 };
    } catch (err) {
        $("#preloader").hide();
        toastify(err.message, "error");
        setTimeout(() => {
            location.reload();
        }, 2000);
    }
}

async function BuyerBidSign(token_id, amount, quantity, collection) {
    try {
        console.log(amount, collection);
        var dat = new Date().getTime();
        var nonce = Math.floor(dat / 1000);
        var signer = await provider.getSigner();
        if (collection == "admin") {
            var assetAddress = NFT_address;
        } else {
            var assetAddress = collection;
        }
        var paymentAddress = ERC_address;
        var token_arr = [];
        token_arr.push(assetAddress);
        token_arr.push(token_id);
        token_arr.push(paymentAddress);
        token_arr.push(amount);
        token_arr.push(quantity);
        token_arr.push(nonce);
        let param0 = token_arr; // rouyalty and tokenuri are null //check quantity, supply
        console.log(param0);
        let hash0 = ethers.utils.solidityKeccak256(
            ["address", "uint256", "address", "uint256", "uint256", "uint256"],
            param0
        );
        console.log(hash0);
        let getSign = await signer.signMessage(ethers.utils.arrayify(hash0));
        let breakDown0 = await ethers.utils.splitSignature(getSign);
        let VRSN0 = [breakDown0.v, breakDown0.r, breakDown0.s, nonce];
        console.log(VRSN0);
        return { status: 1, sign_vrs: VRSN0 };
    } catch (err) {
        $("#preloader").hide();
        toastify(err.message, "error");
        setTimeout(() => {
            location.reload();
        }, 2000);
    }
}

$("#SetRoyalty").on("submit", async function (e) {
    e.preventDefault();
    var partner = $("#PartnerRoyalty").val();
    var buyer = $("#BuyerRoyalty").val();
    var seller = $("#SellerRoyalty").val();
    var marketing = $("#NFTMarketingRoyalty").val();
    var original = $("#OriginalCreatorRoyalty").val();

    var signer = await provider.getSigner();
    var address = await signer.getAddress();
    if (address != "0x5ED629c5BeF31cC3d4f23AF23dFcD408bD5a6348") {
        toastify("Kindly connect owner address", "error");
        setTimeout(() => {
            location.reload();
        }, 2000);
    }

    var buyerfee = await Buyerfees();
    var partnerfee = await Partnerfees();
    var sellerfee = await Sellerfees();

    if (sellerfee != seller) {
        await Trading.connect(signer)
            .setSellerServiceFee(seller * 10)
            .then(async function (res) {
                var sellerTrx = await res.wait();
                console.log("seller", sellerTrx);
            })
            .catch((err) => {
                console.log(err);
                toastify("Error in update seller fee", "error");
                setTimeout(() => {
                    location.reload();
                }, 3000);
            });
    }

    if (buyerfee != buyer) {
        await Trading.connect(signer)
            .setBuyerServiceFee(buyer * 10)
            .then(async (res) => {
                var BuyerTrx = await res.wait();
                console.log("buyer", BuyerTrx);
            })
            .catch((err) => {
                console.log(err);
                toastify("Error in update buyer fee", "error");
                setTimeout(() => {
                    location.reload();
                }, 3000);
            });
    }

    if (partnerfee != partner) {
        await Trading.connect(signer)
            .setPartnerFee(partner * 10)
            .then(async (res) => {
                var PartnerTrx = await res.wait();
                console.log("partner", PartnerTrx);
            })
            .catch((err) => {
                console.log(err);
                toastify("Error in update partner fee", "error");
                setTimeout(() => {
                    location.reload();
                }, 3000);
            });
    }

    $.ajax({
        url: "/admin/change-royalty",
        type: "POST",
        data: {
            original: original,
            marketing: marketing,
            seller: seller,
            buyer: buyer,
            partner: partner,
            _token: token,
        },
    }).done(function (response) {
        if (response == 1) {
            toastify("Royalty updated successfully", "success");
            setTimeout(() => {
                location.reload();
            }, 3000);
        } else {
            toastify("Something went wrong", "error");
            setTimeout(() => {
                location.reload();
            }, 3000);
        }
    });
});

async function Buyerfees() {
    var fees = await Trading.buyerServiceFee();
    fees = fees / 10;
    return fees;
}

async function Partnerfees() {
    var fees = await Trading.partnerServiceFee();
    fees = fees / 10;
    return fees;
}

async function Sellerfees() {
    var fees = await Trading.sellerServiceFee();
    fees = fees / 10;
    return fees;
}

function toastify(message, status) {
    if (status == "success") {
        Toastify({
            text: message,
            close: true,
            position: "right",
            style: {
                background: "linear-gradient(to right, #00b09b, #96c93d)",
            },
        }).showToast();
        return true;
    } else {
        Toastify({
            text: message,
            close: true,
            position: "right",
            style: {
                background: "linear-gradient(to right, #D62121, #C72C2C)",
            },
        }).showToast();
        return false;
    }
}

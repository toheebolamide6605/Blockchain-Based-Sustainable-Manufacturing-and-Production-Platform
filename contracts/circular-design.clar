;; circular-design.clar

;; Define constants for error codes
(define-constant ERR-INVALID-INPUT (err u100))
(define-constant ERR-NOT-AUTHORIZED (err u101))
(define-constant ERR-ALREADY-EXISTS (err u102))
(define-constant ERR-NOT-FOUND (err u103))

;; Define a data structure for a product's circular design attributes
(define-data-var product-count uint u0)

(define-map product-data
  { product-id: uint }
  {
    design-score: uint,
    recyclability-score: uint,
    repairability-score: uint,
    reusability-score: uint,
    material-composition: (string-ascii 256),
    description: (string-ascii 256)
  }
)

;; Define a function to add a new product
(define-public (add-product
  (design-score uint)
  (recyclability-score uint)
  (repairability-score uint)
  (reusability-score uint)
  (material-composition (string-ascii 256))
  (description (string-ascii 256))
)
  (let (
    (product-id (+ u1 (var-get product-count)))
  )
    (asserts! (<= design-score u100) ERR-INVALID-INPUT)
    (asserts! (<= recyclability-score u100) ERR-INVALID-INPUT)
    (asserts! (<= repairability-score u100) ERR-INVALID-INPUT)
    (asserts! (<= reusability-score u100) ERR-INVALID-INPUT)

    (map-insert product-data
      { product-id: product-id }
      {
        design-score: design-score,
        recyclability-score: recyclability-score,
        repairability-score: repairability-score,
        reusability-score: reusability-score,
        material-composition: material-composition,
        description: description
      }
    )
    (var-set product-count product-id)
    (ok product-id)
  )
)

;; Define a function to get product data
(define-read-only (get-product (product-id uint))
  (match (map-get? product-data { product-id: product-id })
    product
    (ok product)
    (err ERR-NOT-FOUND)
  )
)

;; Example usage (can be removed for deployment)
;; (contract-call? 'circular-design add-product u80 u70 u90 u60 "Plastic" "Recycled plastic bottle")
;; (contract-call? 'circular-design get-product u1)

(require rackunit)
(require "extras.rkt")

(provide 
     lit 
     literal-value
     var 
     variable-name
     op 
     operation-name
     call 
     call-operator
     call-operands
     block 
     block-var
     block-rhs
     block-body
     literal?
     variable?
     operation?
     call?
     block?)
(check-location "05" "q2.rkt")
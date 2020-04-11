#include "HeapObject.h"
#include "RefCount.h"

// Returns nonzero iff obj has exactly two strong references.
extern "C" __swift_uint8_t swift_isDuallyReferenced(swift::HeapObject *obj) {
    return obj->refCounts.isDuallyReferenced();
}

// Returns nonzero the number of strong references to obj.  Not currently in
// use.
extern "C" __swift_uint32_t swift_strongRefCount(swift::HeapObject *obj) {
    return obj->refCounts.strongRefCount();
}


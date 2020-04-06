#include "HeapObject.h"
#include "RefCount.h"

extern "C" __swift_uint8_t swift_isDuallyReferenced(swift::HeapObject *obj) {
    return obj->refCounts.isDuallyReferenced();
}

extern "C" __swift_uint32_t swift_strongRefCount(swift::HeapObject *obj) {
    return obj->refCounts.strongRefCount();
}


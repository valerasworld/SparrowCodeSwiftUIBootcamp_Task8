//
//  Wave.metal
//  SparrowCodeSwiftUIBootcamp_Task8
//
//  Created by Валерий Зазулин on 22.03.2024.
//

#include <metal_stdlib>
#include <SwiftUI/SwiftUI_Metal.h>
using namespace metal;


[[ stitchable ]] float2 wave(float2 position, float time, float speed, float frequency, float amplitude) {
    float positionY = position.y + sin((time * speed) + (position.x / frequency)) * amplitude;
    return float2(position.x, positionY);
}



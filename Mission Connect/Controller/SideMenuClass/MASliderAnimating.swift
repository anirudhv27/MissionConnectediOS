//  Mission Connect
//
//  Created by Anirudh Valiveru on 12/22/19.
//  Copyright © 2019 Anirudh Valiveru. All rights reserved.
//

import UIKit

public protocol MASliderAnimating {
    
    func openSlider(_ side: MASliderSide, sliderView: UIView, centerView: UIView, animated: Bool, complete: @escaping (_ finished: Bool) -> Void)
    
    func dismissSlider(_ side: MASliderSide, sliderView: UIView, centerView: UIView, animated: Bool, complete: @escaping (_ finished: Bool) -> Void)
    
    
    /**
    *  Called prior to a rotation event, while a slider view is being shown.
    *
    *  @param side The currently open slider side
    *  @param the containing side view that is shown.
    *  @param the containing centre view.
    */
    func willRotateWithSliderOpen(_ side: MASliderSide, sliderView: UIView, centerView: UIView)
    
    /**
    *  Called following a rotation event, while a slider view is being shown.
    *
    *  @param side The currently open slider side
    *  @param the containing side view that is shown.
    *  @param the containing centre view.
    *  @param a complete block handler to handle cleanup.
    */
    func didRotateWithSliderOpen(_ side: MASliderSide, sliderView: UIView, centerView: UIView)
    
}

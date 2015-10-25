;;; Init
(load "lib/km-2-5-33.fasl")
(km '(untrace))
(km0 '(unload-kb))
(km0 '(load-kb "kb/Nutelliweb.kb")) ;load a chemical nutrition kb

;;; Input
;; cake from : http://nutritiondata.self.com/facts/baked-products/4912/2
(km0 '#$(*cake has
	       (instance-of (Food))
	       (weight ((a WeightValue with (num (500)) (unit (*Gram)))))
	       (servingSize ((a WeightValue with (num (50)) (unit (*Gram)))))
	       (nutritions (
		     (a DietaryFiber with (weight ((a WeightValue with (num (1.6)) (unit (*MilliGram))))))
		     (a Sugars with (weight ((a WeightValue with (num (825)) (unit (*MilliGram))))))
		     (a SaturatedFat with (weight ((a WeightValue with (num (2.4)) (unit (*Gram))))))
		     (a MonounsaturatedFat with (weight ((a WeightValue with (num (4.3)) (unit (*Gram))))))
		     (a PolyunsaturatedFat with (weight ((a WeightValue with (num (0.9)) (unit (*Gram))))))
		     (a Omega3FattyAcid with (weight ((a WeightValue with (num (86.5)) (unit (*MilliGram))))))
		     (a Omega6FattyAcid with (weight ((a WeightValue with (num (825)) (unit (*MilliGram))))))
		     (a Water with (weight ((a WeightValue with (num (9.3)) (unit (*Gram))))))
		     ))
       ))

(km0 '#$(*water has
		(instance-of (Food))
		(weight ((a WeightValue with (num (500)) (unit (*Gram)))))
		(nutritions ((a Water with (weight ((a WeightValue with (num (500)) (unit (*Gram))))))))))


(km0 '#$(*me has
	     (instance-of (Person))
	     (gender (*Male))
	     (age (0.2))
	     (weight ((a WeightValue with (num (50)) (unit (*KiloGram)))))
	     (height ((a HeightValue with (num (170)) (unit (*CentiMeter)))))
	     (|daily taken food| ((:set *cake *water)))
	 ))

;;; Output
(print (km-unique0 '#$(make-sentence (:seq "a cake have cooked and it's total weight is " (the text of (the weight of *cake))))))

(print (km-unique0 '#$(make-sentence (:seq "It's weight of" Sugars "is" (the text of (the weight of (the Sugars nutritions of *cake)))))))

(print (km-unique0 '#$(make-sentence (:seq "My" Gender "is" (the gender of *me)))))

(print (km-unique0 '#$(make-sentence (:seq "My daily calorie status is" ((the |daily taken calorie| of *me) / (the |daily needed calorie| of *me) * 100) "nospace" "%"))))

;;(print (km-unique0 '#$(make-sentence (:seq "My daily nutrition status is" (the |daily taken nutrition| of *me) "nospace" "/" "nospace" (the |daily needed calorie| of *me)))))

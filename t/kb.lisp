(load "lib/km-2-5-33.fasl")

(km '(load-kb "kb/Nutelliweb.kb")) ;load a chemical nutrition kb

(km0 '(*cake has
       (instance-of (Food))
       (nutritions ((
		     (a DietaryFiber with (weight ((a WeightValue with (num (1.6)) (unit (MilliGram))))))
		     (a Sugars with (weight ((a WeightValue with (num (825)) (unit (MilliGram))))))
		     (a Omega6FattyAcid with (weight ((a WeightValue with (num (825)) (unit (MilliGram))))))
		     (a SaturatedFat with (weight ((a WeightValue with (num (2.4)) (unit (Gram))))))
		     (a MonounsaturatedFat with (weight ((a WeightValue with (num (4.3)) (unit (Gram))))))
		     (a PolysaturatedFat with (weight ((a WeightValue with (num (0.9)) (unit (Gram))))))
		     (a Omega3FattyAcid with (weight ((a WeightValue with (num (86.5)) (unit (MilliGram))))))
		     (a Omega6FattyAcid with (weight ((a WeightValue with (num (825)) (unit (MilliGram))))))
		     )))
       ))

# Inflation – Sénégal  
**Analyse des déterminants et prévisions de l’inflation au Sénégal**

## Objectif du projet
L’objectif de ce projet est double :  
- Identifier les principaux déterminants macroéconomiques qui influencent l’inflation au Sénégal.  
- Produire des prévisions fiables de l’inflation à l’aide de modèles économétriques et de techniques de séries temporelles / machine learning.

---

## 1. Analyse descriptive
Cette première étape consiste à analyser l’évolution des différentes séries économiques dans le temps afin de :  
- Identifier les tendances générales de l’inflation ;  
- Détecter d’éventuelles saisonnalités ;  
- Mettre en évidence les périodes caractérisées par des hausses ou des baisses importantes.

---

## 2. Modélisation

### Modèle explicatif économétrique
Un modèle économétrique a été estimé afin de mesurer l’impact des variables macroéconomiques sur l’inflation et d’identifier les facteurs explicatifs majeurs.

### Modèles de prévision
Deux approches ont été comparées :
- Modèle de séries temporelles (SARIMA)
- Modèle de machine learning (XGBoost)

Les performances des modèles ont été évaluées à l’aide de métriques de prévision afin de sélectionner le modèle le plus performant.

---

## 3. Déploiement – Application Shiny
Une application interactive **Shiny** a été développée afin de présenter les résultats de manière claire et accessible.  
L’application permet notamment :
- La visualisation des estimations du modèle économétrique ;
- La comparaison des performances des modèles SARIMA et XGBoost ;
- L’affichage des prévisions obtenues avec le modèle sélectionné.

---

## Conclusion
Les résultats montrent que les meilleures performances de prévision sont obtenues lorsque l’inflation est modélisée à partir de ses propres valeurs passées.  
Cependant, pour l’analyse économique et la prise de décision, l’identification des déterminants de l’inflation reste essentielle, d’où l’importance du modèle économétrique explicatif développé dans cette étude.
"""



The code of an engine consists of D-A-S-E components:

#[D] Data Source and Data Preparator

Data Source reads data from an input source and transforms it into a desired format. Data Preparator preprocesses the data and forwards it to the algorithm for model training.

##[A] Algorithm

The Algorithm component includes the Machine Learning algorithm, and the settings of its parameters, determines how a predictive model is constructed.

##[S] Serving

The Serving component takes prediction queries and returns prediction results. If the engine has multiple algorithms, Serving will combine the results into one. Additionally, business-specific logic can be added in Serving to further customize the final returned results.

##[E] Evaluation Metrics

An Evaluation Metric quantifies prediction accuracy with a numerical score. It can be used for comparing algorithms or algorithm parameter settings.
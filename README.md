```@meta
EditURL = "doc/README.jl"
```

Translation of [currocam](https://github.com/currocam)'s `slim_wrap.py` to Julia.

Workflow example with `SlimWrap` + `PyCall`

## Example

````julia
using SlimWrap
using PyCall
tskit = pyimport("tskit")
pyslim = pyimport("pyslim")
msprime = pyimport("msprime")
````

````
PyObject <module 'msprime' from '/home/arzwa/.local/lib/python3.10/site-packages/msprime/__init__.py'>
````

Define and run the SLiM simulation

````julia
M = SLiMModel(templates.wf)
params = Dict(
    "POPSIZE"=>100,
    "CHRSIZE"=>1_000_000,
    "RECRATE"=>1e-8,
    "NGEN"   =>1000,
    "OUTFILE"=>tempname())
run(M, constants=params)
````

````
Process(`slim -s -6571426364046091660 -l 2 -d "SLIM_WRAP_PARAMS = Dictionary(readFile('/tmp/jl_mNsfUlApW7'))" -p -d "POPSIZE=SLIM_WRAP_PARAMS.getValue('POPSIZE');" -d "NGEN=SLIM_WRAP_PARAMS.getValue('NGEN');" -d "CHRSIZE=SLIM_WRAP_PARAMS.getValue('CHRSIZE');" -d "RECRATE=SLIM_WRAP_PARAMS.getValue('RECRATE');" -d "OUTFILE=SLIM_WRAP_PARAMS.getValue('OUTFILE');" /home/arzwa/dev/SlimWrap/src/templates/wf.slim`, ProcessExited(0))
````

Load and simplify the tree sequence

````julia
ts = tskit.load(params["OUTFILE"])
alive = pyslim.individuals_alive_at(ts, 0) .+ 1
sts = ts.simplify(
    ts.individuals_nodes[alive],
    keep_input_roots=true)
demography = msprime.Demography.from_tree_sequence(sts)
rts = pyslim.recapitate(
    sts, random_seed=11,
    demography=demography,
    ploidy=2,
    recombination_rate=params["RECRATE"]
)
````

```@raw html

        <div>
            <style>
                .tskit-table thead tr th {text-align: left;padding: 0.5em 0.5em;}
                .tskit-table tbody tr td {padding: 0.5em 0.5em;}
                .tskit-table tbody tr td:first-of-type {text-align: left;}
                .tskit-details-label {vertical-align: top; padding-right:5px;}
                .tskit-table-set {display: inline-flex;flex-wrap: wrap;margin: -12px 0 0 -12px;width: calc(100% + 12px);}
                .tskit-table-set-table {margin: 12px 0 0 12px;}
                details {display: inline-block;}
                summary {cursor: pointer; outline: 0; display: list-item;}
            </style>
            <div class="tskit-table-set">
                <div class="tskit-table-set-table">
                    <table class="tskit-table">
                        <thead>
                            <tr>
                                <th style="padding:0;line-height:21px;">
                                    <img style="height: 32px;display: inline-block;padding: 3px 5px 3px 0;" src="https://raw.githubusercontent.com/tskit-dev/administrative/main/tskit_logo.svg"/>
                                    <a target="_blank" href="https://tskit.dev/tskit/docs/latest/python-api.html#the-treesequence-class"> Tree Sequence </a>
                                </th>
                            </tr>
                        </thead>
                        <tbody>
                            <tr><td>Trees</td><td>22</td></tr>
                            <tr><td>Sequence Length</td><td>1 000 000</td></tr>
                            <tr><td>Time Units</td><td>ticks</td></tr>
                            <tr><td>Sample Nodes</td><td>100</td></tr>
                            <tr><td>Total Size</td><td>43.1 KiB</td></tr>
                            <tr>
                                <td>Metadata</td><td style="text-align: left;">
            <div>
                <span class="tskit-details-label"></span>
                <details open>
                    <summary>dict</summary>
                    
            <div>
                <span class="tskit-details-label">SLiM:</span>
                <details >
                    <summary>dict</summary>
                    
            <div>
                <span class="tskit-details-label">chromosomes:</span>
                <details >
                    <summary>list</summary>
                    
            <div>
                <span class="tskit-details-label"></span>
                <details >
                    <summary>dict</summary>
                    id: 1<br/>index: 0<br/>symbol: A<br/>type: A<br/>
                </details>
            </div>
            <br/>
                </details>
            </div>
            <br/>cycle: 1000<br/>file_version: 0.9<br/>model_type: WF<br/>name: sim<br/>nucleotide_based: False<br/>separate_sexes: False<br/>spatial_dimensionality: <br/>spatial_periodicity: <br/>stage: late<br/>
            <div>
                <span class="tskit-details-label">this_chromosome:</span>
                <details >
                    <summary>dict</summary>
                    id: 1<br/>index: 0<br/>symbol: A<br/>type: A<br/>
                </details>
            </div>
            <br/>tick: 1000<br/>
                </details>
            </div>
            <br/>
                </details>
            </div>
            </td>
                            </tr>
                        </tbody>
                    </table>
                </div>
                <div class="tskit-table-set-table">
                    <table class="tskit-table">
                        <thead>
                            <tr>
                                <th style="line-height:21px;">Table</th>
                                <th>Rows</th>
                                <th>Size</th>
                                <th>Has Metadata</th>
                            </tr>
                        </thead>
                        <tbody>
                            
            <tr>
                <td>Edges</td>
                <td>260</td>
                <td>8.1 KiB</td>
                <td style="text-align: center;">
                    
                </td>
            </tr>
        
            <tr>
                <td>Individuals</td>
                <td>100</td>
                <td>11.6 KiB</td>
                <td style="text-align: center;">
                    ✅
                </td>
            </tr>
        
            <tr>
                <td>Migrations</td>
                <td>0</td>
                <td>8 Bytes</td>
                <td style="text-align: center;">
                    
                </td>
            </tr>
        
            <tr>
                <td>Mutations</td>
                <td>0</td>
                <td>1.2 KiB</td>
                <td style="text-align: center;">
                    
                </td>
            </tr>
        
            <tr>
                <td>Nodes</td>
                <td>210</td>
                <td>9.2 KiB</td>
                <td style="text-align: center;">
                    ✅
                </td>
            </tr>
        
            <tr>
                <td>Populations</td>
                <td>1</td>
                <td>2.3 KiB</td>
                <td style="text-align: center;">
                    ✅
                </td>
            </tr>
        
            <tr>
                <td>Provenances</td>
                <td>3</td>
                <td>4.6 KiB</td>
                <td style="text-align: center;">
                    
                </td>
            </tr>
        
            <tr>
                <td>Sites</td>
                <td>0</td>
                <td>16 Bytes</td>
                <td style="text-align: center;">
                    
                </td>
            </tr>
        
                        </tbody>
                    </table>
                </div>
                <div class="tskit-table-set-table">
                    <table class="tskit-table">
                        <thead>
                            <tr>
                                <th>Provenance Timestamp</th>
                                <th>Software Name</th>
                                <th>Version</th>
                                <th>Command</th>
                                <th>Full record</th>
                            </tr>
                        </thead>
                        <tbody>
                            
                <tr>
                    <td>18 Juni, 2025 at 04:49:46 </td>
                    <td>msprime</td>
                    <td>1.3.3</td>
                    <td>sim_ancestry</td>
                    <td>
                        <details>
                            <summary>Details</summary>
                            
            <div>
                <span class="tskit-details-label"></span>
                <details >
                    <summary>dict</summary>
                    schema_version: 1.0.0<br/>
            <div>
                <span class="tskit-details-label">software:</span>
                <details >
                    <summary>dict</summary>
                    name: msprime<br/>version: 1.3.3<br/>
                </details>
            </div>
            <br/>
            <div>
                <span class="tskit-details-label">parameters:</span>
                <details >
                    <summary>dict</summary>
                    command: sim_ancestry<br/>samples: None<br/>
            <div>
                <span class="tskit-details-label">demography:</span>
                <details >
                    <summary>dict</summary>
                    
            <div>
                <span class="tskit-details-label">populations:</span>
                <details >
                    <summary>list</summary>
                    
            <div>
                <span class="tskit-details-label"></span>
                <details >
                    <summary>dict</summary>
                    initial_size: 0<br/>growth_rate: 0<br/>name: p1<br/>description: <br/>
            <div>
                <span class="tskit-details-label">extra_metadata:</span>
                <details >
                    <summary>dict</summary>
                    
                </details>
            </div>
            <br/>default_sampling_time: None<br/>initially_active: None<br/>id: 0<br/>
                </details>
            </div>
            <br/>
                </details>
            </div>
            <br/>
            <div>
                <span class="tskit-details-label">events:</span>
                <details >
                    <summary>list</summary>
                    
                </details>
            </div>
            <br/>
            <div>
                <span class="tskit-details-label">migration_matrix:</span>
                <details >
                    <summary>list</summary>
                    
            <div>
                <span class="tskit-details-label"></span>
                <details >
                    <summary>list</summary>
                     0.0<br/>
                </details>
            </div>
            <br/>
                </details>
            </div>
            <br/>__class__: msprime.demography.Demography<br/>
                </details>
            </div>
            <br/>sequence_length: None<br/>discrete_genome: None<br/>recombination_rate: 1e-08<br/>gene_conversion_rate: None<br/>gene_conversion_tract_length: None<br/>population_size: None<br/>ploidy: 2<br/>model: None<br/>
            <div>
                <span class="tskit-details-label">initial_state:</span>
                <details >
                    <summary>dict</summary>
                    __constant__: __current_ts__<br/>
                </details>
            </div>
            <br/>start_time: None<br/>end_time: None<br/>record_migrations: None<br/>record_full_arg: None<br/>additional_nodes: None<br/>coalescing_segments_only: None<br/>num_labels: None<br/>random_seed: 11<br/>replicate_index: 0<br/>
                </details>
            </div>
            <br/>
            <div>
                <span class="tskit-details-label">environment:</span>
                <details >
                    <summary>dict</summary>
                    
            <div>
                <span class="tskit-details-label">os:</span>
                <details >
                    <summary>dict</summary>
                    system: Linux<br/>node: arzwa-Latitude-7450<br/>release: 6.8.0-60-generic<br/>version: #63~22.04.1-Ubuntu SMP<br/>PREEMPT_DYNAMIC Tue Apr 22<br/>19:00:15 UTC 2<br/>machine: x86_64<br/>
                </details>
            </div>
            <br/>
            <div>
                <span class="tskit-details-label">python:</span>
                <details >
                    <summary>dict</summary>
                    implementation: CPython<br/>version: 3.10.12<br/>
                </details>
            </div>
            <br/>
            <div>
                <span class="tskit-details-label">libraries:</span>
                <details >
                    <summary>dict</summary>
                    
            <div>
                <span class="tskit-details-label">kastore:</span>
                <details >
                    <summary>dict</summary>
                    version: 2.1.1<br/>
                </details>
            </div>
            <br/>
            <div>
                <span class="tskit-details-label">tskit:</span>
                <details >
                    <summary>dict</summary>
                    version: 0.6.4<br/>
                </details>
            </div>
            <br/>
            <div>
                <span class="tskit-details-label">gsl:</span>
                <details >
                    <summary>dict</summary>
                    version: 2.6<br/>
                </details>
            </div>
            <br/>
                </details>
            </div>
            <br/>
                </details>
            </div>
            <br/>
                </details>
            </div>
            
                        </details>
                    </td>
                </tr>
            
                <tr>
                    <td>18 Juni, 2025 at 04:49:46 </td>
                    <td>tskit</td>
                    <td>0.6.4</td>
                    <td>simplify</td>
                    <td>
                        <details>
                            <summary>Details</summary>
                            
            <div>
                <span class="tskit-details-label"></span>
                <details >
                    <summary>dict</summary>
                    schema_version: 1.0.0<br/>
            <div>
                <span class="tskit-details-label">software:</span>
                <details >
                    <summary>dict</summary>
                    name: tskit<br/>version: 0.6.4<br/>
                </details>
            </div>
            <br/>
            <div>
                <span class="tskit-details-label">parameters:</span>
                <details >
                    <summary>dict</summary>
                    command: simplify<br/>TODO: add simplify parameters<br/>
                </details>
            </div>
            <br/>
            <div>
                <span class="tskit-details-label">environment:</span>
                <details >
                    <summary>dict</summary>
                    
            <div>
                <span class="tskit-details-label">os:</span>
                <details >
                    <summary>dict</summary>
                    system: Linux<br/>node: arzwa-Latitude-7450<br/>release: 6.8.0-60-generic<br/>version: #63~22.04.1-Ubuntu SMP<br/>PREEMPT_DYNAMIC Tue Apr 22<br/>19:00:15 UTC 2<br/>machine: x86_64<br/>
                </details>
            </div>
            <br/>
            <div>
                <span class="tskit-details-label">python:</span>
                <details >
                    <summary>dict</summary>
                    implementation: CPython<br/>version: 3.10.12<br/>
                </details>
            </div>
            <br/>
            <div>
                <span class="tskit-details-label">libraries:</span>
                <details >
                    <summary>dict</summary>
                    
            <div>
                <span class="tskit-details-label">kastore:</span>
                <details >
                    <summary>dict</summary>
                    version: 2.1.1<br/>
                </details>
            </div>
            <br/>
                </details>
            </div>
            <br/>
                </details>
            </div>
            <br/>
                </details>
            </div>
            
                        </details>
                    </td>
                </tr>
            
                <tr>
                    <td>18 Juni, 2025 at 04:49:46 </td>
                    <td>SLiM</td>
                    <td>5.0</td>
                    <td>['slim', '-s', '-6571426364046091660', '-l', '2', '-d', "SLIM_WRAP_PARAMS = Dictionary(readFile('/tmp/jl_mNsfUlApW7'))", '-p', '-d', "POPSIZE=SLIM_WRAP_PARAMS.getValue('POPSIZE');", '-d', "NGEN=SLIM_WRAP_PARAMS.getValue('NGEN');", '-d', "CHRSIZE=SLIM_WRAP_PARAMS.getValue('CHRSIZE');", '-d', "RECRATE=SLIM_WRAP_PARAMS.getValue('RECRATE');", '-d', "OUTFILE=SLIM_WRAP_PARAMS.getValue('OUTFILE');", '/home/arzwa/dev/SlimWrap/src/templates/wf.slim']</td>
                    <td>
                        <details>
                            <summary>Details</summary>
                            
            <div>
                <span class="tskit-details-label"></span>
                <details >
                    <summary>dict</summary>
                    
            <div>
                <span class="tskit-details-label">environment:</span>
                <details >
                    <summary>dict</summary>
                    
            <div>
                <span class="tskit-details-label">os:</span>
                <details >
                    <summary>dict</summary>
                    machine: x86_64<br/>node: arzwa-Latitude-7450<br/>release: 6.8.0-60-generic<br/>system: Linux<br/>version: #63~22.04.1-Ubuntu SMP<br/>PREEMPT_DYNAMIC Tue Apr 22<br/>19:00:15 UTC 2<br/>
                </details>
            </div>
            <br/>
                </details>
            </div>
            <br/>
            <div>
                <span class="tskit-details-label">metadata:</span>
                <details >
                    <summary>dict</summary>
                    
            <div>
                <span class="tskit-details-label">individuals:</span>
                <details >
                    <summary>dict</summary>
                    
            <div>
                <span class="tskit-details-label">flags:</span>
                <details >
                    <summary>dict</summary>
                    
            <div>
                <span class="tskit-details-label">16:</span>
                <details >
                    <summary>dict</summary>
                    description: the individual was alive at<br/>the time the file was written<br/>name: SLIM_TSK_INDIVIDUAL_ALIVE<br/>
                </details>
            </div>
            <br/>
            <div>
                <span class="tskit-details-label">17:</span>
                <details >
                    <summary>dict</summary>
                    description: the individual was requested<br/>by the user to be permanently<br/>remembered<br/>name: SLIM_TSK_INDIVIDUAL_REMEMBERED<br/>
                </details>
            </div>
            <br/>
            <div>
                <span class="tskit-details-label">18:</span>
                <details >
                    <summary>dict</summary>
                    description: the individual was requested<br/>by the user to be retained<br/>only if its nodes continue to<br/>exist in the t...<br/>name: SLIM_TSK_INDIVIDUAL_RETAINED<br/>
                </details>
            </div>
            <br/>
                </details>
            </div>
            <br/>
                </details>
            </div>
            <br/>
                </details>
            </div>
            <br/>
            <div>
                <span class="tskit-details-label">parameters:</span>
                <details >
                    <summary>dict</summary>
                    
            <div>
                <span class="tskit-details-label">command:</span>
                <details >
                    <summary>list</summary>
                     slim<br/> -s<br/> -6571426364046091660<br/> -l<br/> 2<br/> -d<br/> SLIM_WRAP_PARAMS = Dictionary(<br/>readFile(&#x27;/tmp/jl_mNsfUlApW7&#x27;)<br/>)<br/> -p<br/> -d<br/> POPSIZE=SLIM_WRAP_PARAMS.getVa<br/>lue(&#x27;POPSIZE&#x27;);<br/> -d<br/> NGEN=SLIM_WRAP_PARAMS.getValue<br/>(&#x27;NGEN&#x27;);<br/> -d<br/> CHRSIZE=SLIM_WRAP_PARAMS.getVa<br/>lue(&#x27;CHRSIZE&#x27;);<br/> -d<br/> RECRATE=SLIM_WRAP_PARAMS.getVa<br/>lue(&#x27;RECRATE&#x27;);<br/> -d<br/> OUTFILE=SLIM_WRAP_PARAMS.getVa<br/>lue(&#x27;OUTFILE&#x27;);<br/> /home/arzwa/dev/SlimWrap/src/t<br/>emplates/wf.slim<br/>
                </details>
            </div>
            <br/>model: initialize() {<br/>initializeTreeSeq();<br/>initializeMutationRate(0);    <br/>initializeMutationType(&quot;m1&quot;,..<br/>.<br/>model_hash: 98d817e62bb7955dfc2a2482d47889<br/>1068d1f82b9884350c795e23c383a4<br/>5dea<br/>model_type: WF<br/>nucleotide_based: False<br/>seed: 11875317709663459956<br/>separate_sexes: False<br/>spatial_dimensionality: <br/>spatial_periodicity: <br/>stage: late<br/>
                </details>
            </div>
            <br/>
            <div>
                <span class="tskit-details-label">resources:</span>
                <details >
                    <summary>dict</summary>
                    elapsed_time: 0.030397331<br/>max_memory: 1076510720<br/>sys_time: 0.002015<br/>user_time: 0.030229<br/>
                </details>
            </div>
            <br/>schema_version: 1.1.0<br/>
            <div>
                <span class="tskit-details-label">slim:</span>
                <details >
                    <summary>dict</summary>
                    cycle: 1000<br/>file_version: 0.9<br/>name: sim<br/>tick: 1000<br/>
                </details>
            </div>
            <br/>
            <div>
                <span class="tskit-details-label">software:</span>
                <details >
                    <summary>dict</summary>
                    name: SLiM<br/>version: 5.0<br/>
                </details>
            </div>
            <br/>
                </details>
            </div>
            
                        </details>
                    </td>
                </tr>
            
                        </tbody>
                    </table>
                </div>
            </div>
        </div>
    
```

Simulate neutral mutations

````julia
mts = msprime.sim_mutations(
    ts, random_seed=11,
    rate=1e-8,
    keep=false
)
````

```@raw html

        <div>
            <style>
                .tskit-table thead tr th {text-align: left;padding: 0.5em 0.5em;}
                .tskit-table tbody tr td {padding: 0.5em 0.5em;}
                .tskit-table tbody tr td:first-of-type {text-align: left;}
                .tskit-details-label {vertical-align: top; padding-right:5px;}
                .tskit-table-set {display: inline-flex;flex-wrap: wrap;margin: -12px 0 0 -12px;width: calc(100% + 12px);}
                .tskit-table-set-table {margin: 12px 0 0 12px;}
                details {display: inline-block;}
                summary {cursor: pointer; outline: 0; display: list-item;}
            </style>
            <div class="tskit-table-set">
                <div class="tskit-table-set-table">
                    <table class="tskit-table">
                        <thead>
                            <tr>
                                <th style="padding:0;line-height:21px;">
                                    <img style="height: 32px;display: inline-block;padding: 3px 5px 3px 0;" src="https://raw.githubusercontent.com/tskit-dev/administrative/main/tskit_logo.svg"/>
                                    <a target="_blank" href="https://tskit.dev/tskit/docs/latest/python-api.html#the-treesequence-class"> Tree Sequence </a>
                                </th>
                            </tr>
                        </thead>
                        <tbody>
                            <tr><td>Trees</td><td>24</td></tr>
                            <tr><td>Sequence Length</td><td>1 000 000</td></tr>
                            <tr><td>Time Units</td><td>ticks</td></tr>
                            <tr><td>Sample Nodes</td><td>200</td></tr>
                            <tr><td>Total Size</td><td>57.6 KiB</td></tr>
                            <tr>
                                <td>Metadata</td><td style="text-align: left;">
            <div>
                <span class="tskit-details-label"></span>
                <details open>
                    <summary>dict</summary>
                    
            <div>
                <span class="tskit-details-label">SLiM:</span>
                <details >
                    <summary>dict</summary>
                    
            <div>
                <span class="tskit-details-label">chromosomes:</span>
                <details >
                    <summary>list</summary>
                    
            <div>
                <span class="tskit-details-label"></span>
                <details >
                    <summary>dict</summary>
                    id: 1<br/>index: 0<br/>symbol: A<br/>type: A<br/>
                </details>
            </div>
            <br/>
                </details>
            </div>
            <br/>cycle: 1000<br/>file_version: 0.9<br/>model_type: WF<br/>name: sim<br/>nucleotide_based: False<br/>separate_sexes: False<br/>spatial_dimensionality: <br/>spatial_periodicity: <br/>stage: late<br/>
            <div>
                <span class="tskit-details-label">this_chromosome:</span>
                <details >
                    <summary>dict</summary>
                    id: 1<br/>index: 0<br/>symbol: A<br/>type: A<br/>
                </details>
            </div>
            <br/>tick: 1000<br/>
                </details>
            </div>
            <br/>
                </details>
            </div>
            </td>
                            </tr>
                        </tbody>
                    </table>
                </div>
                <div class="tskit-table-set-table">
                    <table class="tskit-table">
                        <thead>
                            <tr>
                                <th style="line-height:21px;">Table</th>
                                <th>Rows</th>
                                <th>Size</th>
                                <th>Has Metadata</th>
                            </tr>
                        </thead>
                        <tbody>
                            
            <tr>
                <td>Edges</td>
                <td>445</td>
                <td>13.9 KiB</td>
                <td style="text-align: center;">
                    
                </td>
            </tr>
        
            <tr>
                <td>Individuals</td>
                <td>100</td>
                <td>11.6 KiB</td>
                <td style="text-align: center;">
                    ✅
                </td>
            </tr>
        
            <tr>
                <td>Migrations</td>
                <td>0</td>
                <td>8 Bytes</td>
                <td style="text-align: center;">
                    
                </td>
            </tr>
        
            <tr>
                <td>Mutations</td>
                <td>30</td>
                <td>2.3 KiB</td>
                <td style="text-align: center;">
                    
                </td>
            </tr>
        
            <tr>
                <td>Nodes</td>
                <td>389</td>
                <td>15.7 KiB</td>
                <td style="text-align: center;">
                    ✅
                </td>
            </tr>
        
            <tr>
                <td>Populations</td>
                <td>2</td>
                <td>2.3 KiB</td>
                <td style="text-align: center;">
                    ✅
                </td>
            </tr>
        
            <tr>
                <td>Provenances</td>
                <td>2</td>
                <td>3.6 KiB</td>
                <td style="text-align: center;">
                    
                </td>
            </tr>
        
            <tr>
                <td>Sites</td>
                <td>30</td>
                <td>766 Bytes</td>
                <td style="text-align: center;">
                    
                </td>
            </tr>
        
                        </tbody>
                    </table>
                </div>
                <div class="tskit-table-set-table">
                    <table class="tskit-table">
                        <thead>
                            <tr>
                                <th>Provenance Timestamp</th>
                                <th>Software Name</th>
                                <th>Version</th>
                                <th>Command</th>
                                <th>Full record</th>
                            </tr>
                        </thead>
                        <tbody>
                            
                <tr>
                    <td>18 Juni, 2025 at 04:49:46 </td>
                    <td>msprime</td>
                    <td>1.3.3</td>
                    <td>sim_mutations</td>
                    <td>
                        <details>
                            <summary>Details</summary>
                            
            <div>
                <span class="tskit-details-label"></span>
                <details >
                    <summary>dict</summary>
                    schema_version: 1.0.0<br/>
            <div>
                <span class="tskit-details-label">software:</span>
                <details >
                    <summary>dict</summary>
                    name: msprime<br/>version: 1.3.3<br/>
                </details>
            </div>
            <br/>
            <div>
                <span class="tskit-details-label">parameters:</span>
                <details >
                    <summary>dict</summary>
                    command: sim_mutations<br/>
            <div>
                <span class="tskit-details-label">tree_sequence:</span>
                <details >
                    <summary>dict</summary>
                    __constant__: __current_ts__<br/>
                </details>
            </div>
            <br/>rate: 1e-08<br/>model: None<br/>start_time: None<br/>end_time: None<br/>discrete_genome: None<br/>keep: False<br/>random_seed: 11<br/>
                </details>
            </div>
            <br/>
            <div>
                <span class="tskit-details-label">environment:</span>
                <details >
                    <summary>dict</summary>
                    
            <div>
                <span class="tskit-details-label">os:</span>
                <details >
                    <summary>dict</summary>
                    system: Linux<br/>node: arzwa-Latitude-7450<br/>release: 6.8.0-60-generic<br/>version: #63~22.04.1-Ubuntu SMP<br/>PREEMPT_DYNAMIC Tue Apr 22<br/>19:00:15 UTC 2<br/>machine: x86_64<br/>
                </details>
            </div>
            <br/>
            <div>
                <span class="tskit-details-label">python:</span>
                <details >
                    <summary>dict</summary>
                    implementation: CPython<br/>version: 3.10.12<br/>
                </details>
            </div>
            <br/>
            <div>
                <span class="tskit-details-label">libraries:</span>
                <details >
                    <summary>dict</summary>
                    
            <div>
                <span class="tskit-details-label">kastore:</span>
                <details >
                    <summary>dict</summary>
                    version: 2.1.1<br/>
                </details>
            </div>
            <br/>
            <div>
                <span class="tskit-details-label">tskit:</span>
                <details >
                    <summary>dict</summary>
                    version: 0.6.4<br/>
                </details>
            </div>
            <br/>
            <div>
                <span class="tskit-details-label">gsl:</span>
                <details >
                    <summary>dict</summary>
                    version: 2.6<br/>
                </details>
            </div>
            <br/>
                </details>
            </div>
            <br/>
                </details>
            </div>
            <br/>
                </details>
            </div>
            
                        </details>
                    </td>
                </tr>
            
                <tr>
                    <td>18 Juni, 2025 at 04:49:46 </td>
                    <td>SLiM</td>
                    <td>5.0</td>
                    <td>['slim', '-s', '-6571426364046091660', '-l', '2', '-d', "SLIM_WRAP_PARAMS = Dictionary(readFile('/tmp/jl_mNsfUlApW7'))", '-p', '-d', "POPSIZE=SLIM_WRAP_PARAMS.getValue('POPSIZE');", '-d', "NGEN=SLIM_WRAP_PARAMS.getValue('NGEN');", '-d', "CHRSIZE=SLIM_WRAP_PARAMS.getValue('CHRSIZE');", '-d', "RECRATE=SLIM_WRAP_PARAMS.getValue('RECRATE');", '-d', "OUTFILE=SLIM_WRAP_PARAMS.getValue('OUTFILE');", '/home/arzwa/dev/SlimWrap/src/templates/wf.slim']</td>
                    <td>
                        <details>
                            <summary>Details</summary>
                            
            <div>
                <span class="tskit-details-label"></span>
                <details >
                    <summary>dict</summary>
                    
            <div>
                <span class="tskit-details-label">environment:</span>
                <details >
                    <summary>dict</summary>
                    
            <div>
                <span class="tskit-details-label">os:</span>
                <details >
                    <summary>dict</summary>
                    machine: x86_64<br/>node: arzwa-Latitude-7450<br/>release: 6.8.0-60-generic<br/>system: Linux<br/>version: #63~22.04.1-Ubuntu SMP<br/>PREEMPT_DYNAMIC Tue Apr 22<br/>19:00:15 UTC 2<br/>
                </details>
            </div>
            <br/>
                </details>
            </div>
            <br/>
            <div>
                <span class="tskit-details-label">metadata:</span>
                <details >
                    <summary>dict</summary>
                    
            <div>
                <span class="tskit-details-label">individuals:</span>
                <details >
                    <summary>dict</summary>
                    
            <div>
                <span class="tskit-details-label">flags:</span>
                <details >
                    <summary>dict</summary>
                    
            <div>
                <span class="tskit-details-label">16:</span>
                <details >
                    <summary>dict</summary>
                    description: the individual was alive at<br/>the time the file was written<br/>name: SLIM_TSK_INDIVIDUAL_ALIVE<br/>
                </details>
            </div>
            <br/>
            <div>
                <span class="tskit-details-label">17:</span>
                <details >
                    <summary>dict</summary>
                    description: the individual was requested<br/>by the user to be permanently<br/>remembered<br/>name: SLIM_TSK_INDIVIDUAL_REMEMBERED<br/>
                </details>
            </div>
            <br/>
            <div>
                <span class="tskit-details-label">18:</span>
                <details >
                    <summary>dict</summary>
                    description: the individual was requested<br/>by the user to be retained<br/>only if its nodes continue to<br/>exist in the t...<br/>name: SLIM_TSK_INDIVIDUAL_RETAINED<br/>
                </details>
            </div>
            <br/>
                </details>
            </div>
            <br/>
                </details>
            </div>
            <br/>
                </details>
            </div>
            <br/>
            <div>
                <span class="tskit-details-label">parameters:</span>
                <details >
                    <summary>dict</summary>
                    
            <div>
                <span class="tskit-details-label">command:</span>
                <details >
                    <summary>list</summary>
                     slim<br/> -s<br/> -6571426364046091660<br/> -l<br/> 2<br/> -d<br/> SLIM_WRAP_PARAMS = Dictionary(<br/>readFile(&#x27;/tmp/jl_mNsfUlApW7&#x27;)<br/>)<br/> -p<br/> -d<br/> POPSIZE=SLIM_WRAP_PARAMS.getVa<br/>lue(&#x27;POPSIZE&#x27;);<br/> -d<br/> NGEN=SLIM_WRAP_PARAMS.getValue<br/>(&#x27;NGEN&#x27;);<br/> -d<br/> CHRSIZE=SLIM_WRAP_PARAMS.getVa<br/>lue(&#x27;CHRSIZE&#x27;);<br/> -d<br/> RECRATE=SLIM_WRAP_PARAMS.getVa<br/>lue(&#x27;RECRATE&#x27;);<br/> -d<br/> OUTFILE=SLIM_WRAP_PARAMS.getVa<br/>lue(&#x27;OUTFILE&#x27;);<br/> /home/arzwa/dev/SlimWrap/src/t<br/>emplates/wf.slim<br/>
                </details>
            </div>
            <br/>model: initialize() {<br/>initializeTreeSeq();<br/>initializeMutationRate(0);    <br/>initializeMutationType(&quot;m1&quot;,..<br/>.<br/>model_hash: 98d817e62bb7955dfc2a2482d47889<br/>1068d1f82b9884350c795e23c383a4<br/>5dea<br/>model_type: WF<br/>nucleotide_based: False<br/>seed: 11875317709663459956<br/>separate_sexes: False<br/>spatial_dimensionality: <br/>spatial_periodicity: <br/>stage: late<br/>
                </details>
            </div>
            <br/>
            <div>
                <span class="tskit-details-label">resources:</span>
                <details >
                    <summary>dict</summary>
                    elapsed_time: 0.030397331<br/>max_memory: 1076510720<br/>sys_time: 0.002015<br/>user_time: 0.030229<br/>
                </details>
            </div>
            <br/>schema_version: 1.1.0<br/>
            <div>
                <span class="tskit-details-label">slim:</span>
                <details >
                    <summary>dict</summary>
                    cycle: 1000<br/>file_version: 0.9<br/>name: sim<br/>tick: 1000<br/>
                </details>
            </div>
            <br/>
            <div>
                <span class="tskit-details-label">software:</span>
                <details >
                    <summary>dict</summary>
                    name: SLiM<br/>version: 5.0<br/>
                </details>
            </div>
            <br/>
                </details>
            </div>
            
                        </details>
                    </td>
                </tr>
            
                        </tbody>
                    </table>
                </div>
            </div>
        </div>
    
```

Get coalescence times

````julia
tmrca = mts.diversity(mts.samples(population=1),
    mode="branch", windows=0:100_000:params["CHRSIZE"]) / 2
````

````
10-element Vector{Float64}:
 109.5505912603015
 108.20839195979903
 108.6751948180904
 134.90611603618083
 186.9999951547737
 190.72989136683398
 191.6881909547737
 187.08874380452247
 180.50950993969835
 135.11960366633144
````

---

*This page was generated using [Literate.jl](https://github.com/fredrikekre/Literate.jl).*


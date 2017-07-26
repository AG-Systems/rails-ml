
class Post extends React.Component {
  constructor(props) {
    super(props);

    this.state = {
      feedback: 'Loading...',
      calltoaction: 'Loading....'
    };
  }
  componentDidMount() 
  {
      this.setState({feedback: this.props.feed}, function() 
      {
          console.log(this.state.feedback * 100);
      }); 
      this.setState({calltoaction: this.props.calltoaction}, function() 
      {
          console.log(this.state.calltoaction * 10);
      });  
  }
  help()
  {
    var modal = document.getElementById('myModal');
    modal.style.display = "block";
    var span = document.getElementsByClassName("closehelp")[0];
    span.onclick = function() {
        modal.style.display = "none";
    }
    
    window.onclick = function(event) {
        if (event.target == modal) {
            modal.style.display = "none";
        }
    }
  }
  render() { 
    return(
           <div>
            <div className="card-images"> 
                    <img src={this.props.image} alt={this.props.title} id="pic-image"/>
                    <div className="container-images">
                        <h2><b>Title: {this.props.title}</b></h2>
                        {/*
                        <p><b>Feedback: </b></p>
                          <div id="myModal" className="modal">
                          
                            
                            <div className="modal-content">
                              <span className="closehelp">&times;</span>
                              <h1>Help</h1>
                              <b>Clarity of ad: </b>
                              <p>This is how easy and/or easily recognizable your ad is</p>
                              <p>If the score is low, that means the computer was not able to figure out 
                              what your ad was </p>
                              <b>Memorability: </b>
                              <p> This is how unique your ad is. Generelly for best results in the real world
                              we reccomend your ad to be played really often or have it be so unique that 
                              everybody remembers the ad </p>
                              <b>Attention Grab: </b>
                              <p> How much attention your ad grabs. This score might be irelavant depending on 
                              what platform you run on. For example, running a dark ad on facebook is a good idea.
                              The score might say otherwise.
                              </p>
                            </div>
                          
                          </div>
                        
                        <p>Clarity of ad: {Math.round(this.state.feedback * 100)}% <span className="glyphicon glyphicon-question-sign" onClick={this.help}></span></p>
                        <div className="progress">
                          <div className="progress-bar progress-bar-custom" role="progressbar" aria-valuenow={this.state.feedback * 100} 
                          aria-valuemin="0" aria-valuemax="100" style={{width:this.state.feedback * 100 + "%"}}>
                          </div>
                        </div>
                        <p>Ad Memorability: {Math.round(this.state.calltoaction* 10)}% <span className="glyphicon glyphicon-question-sign" onClick={this.help}></span></p>
                        <div className="progress">
                          <div className="progress-bar progress-bar-custom" role="progressbar" aria-valuenow={this.state.calltoaction * 10} 
                          aria-valuemin="0" aria-valuemax="100" style={{width:this.props.calltoaction * 10 + "%"}}>
                          </div>
                        </div>     

                        <p>Attention Grab: {Math.round(this.props.colorstatus * 10)}% <span className="glyphicon glyphicon-question-sign" onClick={this.help}></span></p>
                        <div className="progress">
                          <div className="progress-bar progress-bar-custom" role="progressbar" aria-valuenow={this.props.colorstatus * 10} 
                          aria-valuemin="0" aria-valuemax="100" style={{width:this.props.colorstatus * 10 + "%"}}>
                          </div>
                        </div>
                        
                        <p><b>{this.props.status} this ad </b></p>
                        */}
                        <p><b>Status: <p>{this.props.status} </p></b></p>
                        <div id="break"></div>
                        <p><b>Overall Rating: {this.props.rating}/10</b></p>
                    </div>
            </div>
            <br/>
        </div>
        )   
  }
}





/*

class Paid extends React.Component {
  constructor(props) {
    super(props);

    this.state = {
      feedback: 'Loading...'
    };
  }
  componentDidMount() 
  {
      this.setState({feedback: this.props.feed}, function() 
      {
          console.log(this.state.feedback);
      });   
  }
  render() {
    return(
        <div>
            <div className="card-images">
                <img src={this.props.image} alt={this.props.title} id="ad-image"/>
                <div className="container-images">
                    <h3><b>{this.props.title}</b></h3>
                    <p><b>Feedback: </b></p>
                    {this.state.feedback.split("\n").map(i => {
                          return <p>{i}</p>;
                    })}
                    <hr/>
                    <p><b>Image Recognition:</b></p>
                    {this.props.analysis.split("\n").map(i => {
                          return <p>{i}</p>;
                    })}

                    <hr/>
                    <p>Rating: {this.props.rating}/10</p>
                </div>
            </div>
        </div>
        )   
  }
}



      var that = this;
      fetch("//api.giphy.com/v1/gifs/search?q=$" + that.props.title + "&api_key=dc6zaTOxFJmzC")
        .then(function(response) {
          return response.json()
        }).then(function(json) {
              // console.log('parsed json', json.data[0].images.fixed_height.url)
               that.setState({feedback: json.data[0].images.fixed_height.url}, function () 
               {
                  console.log(that.state.feedback);
                });
        }).catch(function(ex) {
          console.log('parsing failed', ex)
        })
        
  */
  
